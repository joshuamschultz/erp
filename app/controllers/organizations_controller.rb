class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy organization_info populate add_comment delete_comment]
  before_action :set_page_info
  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions

  autocomplete :organization, :organization_name, full: true

  def view_permissions
    if user_signed_in? && current_user.is_logistics?
      authorize! :edit, Organization
    end
  end

  def user_permissions
    if user_signed_in? && current_user.is_customer?
      authorize! :edit, Organization
    end
  end

  def set_page_info
    unless user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      if params[:type1].present? && params[:type2].present?
        # if it is a vendor qualification report, activate report menu
        @menus[:reports][:active] = 'active'
      else
        # if it is a regular org view, activate contacts menu
        @menus[:contacts][:active] = 'active'
      end
    end
  end

  def get_autocomplete_items(parameters)
    items = active_record_get_autocomplete_items(parameters)
    items = items.organizations(params[:type])
  end

  def index
    # if there is an org_type present
    if params[:type]
      # Obtain the org_type from the params
      @org_type = MasterType.find_by_type_value(params[:type])
      # get all the organziations with that org type (support, vendor, customer)
      @organizations = @org_type.type_based_organizations
      # if type 1 is in the params (I think this states vendor)
      # and type 2 is in the params (I found this can be the report vendor qualification)
      # Then organizations is only orgs meeting the criteria shown (vendors near expiration)
    elsif params[:type1].present? && params[:type2].present?
      @org_type = MasterType.find_by_type_value(params[:type1])
      # TODO: move this to a model scope
      @organizations = @org_type.type_based_organizations.where('(vendor_expiration_date >= ? AND vendor_expiration_date <= ?) OR vendor_expiration_date IS NULL', Date.today, Date.today + 29)
    else
      # if none of the above is true, get all organizaitons.
      @organizations = Organization.all
    end

    respond_to do |format|
      format.html # index.html.erb
      @orgs = []
      format.json do
        @organizations = @organizations.select do |organization|
          org = {}
          organization.attributes.each do |key, value|
            org[key] = value
          end
          org[:organization_name] = "<a href='#{organization_path(organization)}'>#{organization[:organization_name]}</a>"
          org[:organization_expiration_date] = organization.vendor_expiration_date
          org[:quality_rating] = organization. vendor_quality.quality_name if params[:type1].present? && params[:type2].present?
          org[:organization_email] = "<a href='mailto:#{organization.organization_email}' target='_top'>#{organization.organization_email}</a>"

          if can? :edit, Organization
            org[:links] = CommonActions.object_crud_paths(nil, edit_organization_path(organization), nil)
          else
            org[:links] = ''
          end
          @orgs.push(org)
        end
        render json: { aaData: @orgs }
      end
    end
  end

  def mobile_api
    @organizations = Organization.all
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        render json: @organizations
      end
    end
  end

  # GET /organizations/1chuby
  # GET /organizations/1.json
  def show
    # set polymorphic
    @contactable = @organization
    @attachable = @organization
    @addressable = @organization
    # default contact type to show is addresses
    @contact_type = 'contact'

    @address_type = 'address'

    # load comments
    @notes = @organization.comments.where(comment_type: 'note').order('created_at desc') if @organization

    # load tags
    @tags = @organization.present? ? @organization.comments.where(comment_type: 'tag').order('created_at desc') : []

    # load Purchase Orders
    @po_headers = PoHeader.where(organization: @organization)

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        case params[:type]
        when 'min_quality'
          min_vendor_quality = @organization.min_vendor_quality.present? ? @organization.min_vendor_quality.quality_name : ''
          render json: { min_vendor_quality: min_vendor_quality }
        when 'quality_level'
          quality_level = @organization.customer_quality.present? ? @organization.customer_quality : ''
          render json: { quality_level: quality_level }
        else
          render json: @organization
        end
      end
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit; end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      flash[:notice] = 'Organization created!'
      # tells certain role (in common_actions) that an org (currently vendor)
      # is created
      CommonActions.notification_process('Organization', @organization)
    end
    respond_with(@organization)
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    if @organization.update_attributes(organization_params)
      flash[:notice] = 'Organization updated!'
      # tells certain role (in common_actions) that an org (currently vendor)
      # is updated
      CommonActions.notification_process('Organization', @organization)
    end
    respond_with(@organization)
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_with(:organizations)
    # respond_to do |format|
    #  format.html { redirect_to organizations_url }
    #  format.json { head :no_content }
    # end
  end

  def populate
    # TODO: remove tags all together
    # TODO and have processes auto add to a vendor when we purchase it from them
    # TODO and have processes auto add to a customer, when we purchase for an item
    # TODO that they buy
    if params[:type] == 'tag'
      tags = params[:tags].split(',')
      Comment.process_comments(current_user, @organization, tags, params[:type])
    elsif params[:type] == 'process'
      OrganizationProcess.process_organization_processes(current_user, @organization, params[:processes])
    end
    redirect_to @organization
  end

  def add_comment
    if params[:comment].present? && params[:type] == 'note'
      Comment.process_comments(current_user, @organization, [params[:comment]], params[:type])
      @notes = @organization.comments.where(comment_type: 'note').order('created_at desc') if @organization
      respond_to do |format|
        format.js { render 'comment.js.erb' }
      end
    end
  end

  def delete_comment
    @organization.comments.where(id: params[:comment_id]).first.destroy!
    @notes = @organization.comments.where(comment_type: 'note').order('created_at desc') if @organization
    respond_to do |format|
      format.js { render 'comment.js.erb' }
    end
  end

  def organization_info
    if @organization
      render layout: false
    else
      render(text: '') && return
    end
  end

  def main_address
    @organization = Organization.find(params[:organization_id])
  end

  private

  def set_organization
    @organization = Organization.find_by(id: params[:id])
  end

  def organization_params
    params.require(:organization).permit(:customer_contact_type_id, :customer_max_quality_id, :customer_min_quality_id,
                                         :organization_address_1, :organization_address_2, :organization_city, :organization_country,
                                         :organization_created_id, :organization_description, :organization_email, :organization_fax,
                                         :organization_name, :organization_notes, :organization_short_name, :organization_state,
                                         :organization_telephone, :organization_type_id, :organization_updated_id, :organization_website,
                                         :organization_zipcode, :vendor_expiration_date, :user_id, :territory_id, :customer_quality_id,
                                         :vendor_quality_id, :organization_complete, :organization_active, :notification_attributes)
  end
end
