class OrganizationsController < ApplicationController
  before_filter :set_page_info

  autocomplete :organization, :organization_name, :full => true
  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
    if  user_signed_in? && current_user.is_logistics?
        authorize! :edit, Organization
    end 
  end

  def user_permissions
    if  user_signed_in? && current_user.is_customer? 
        authorize! :edit, Organization
    end 
  end

  def set_page_info
    unless user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
      unless params[:type1].present? && params[:type2].present?
        @menus[:contacts][:active] = "active" 
      else
        @menus[:reports][:active] = "active"
      end
    end
  end

  def get_autocomplete_items(parameters)
    items = active_record_get_autocomplete_items(parameters)    
    items = items.organizations(params[:type])
  end

  # GET /organizations
  # GET /organizations.json
  def index
    if params[:type]
      @org_type = MasterType.find_by_type_value(params[:type])
      @organizations = @org_type.type_based_organizations
    elsif params[:type1].present? && params[:type2].present?
      @org_type = MasterType.find_by_type_value(params[:type1])
      @organizations = @org_type.type_based_organizations.where("(vendor_expiration_date >= ? AND vendor_expiration_date <= ?) OR vendor_expiration_date IS NULL", Date.today, Date.today+29)
    else
      @organizations = Organization.all
    end

    respond_to do |format|
      format.html # index.html.erb
      @orgs = Array.new
      format.json {
        @organizations = @organizations.select{|organization| 
          org = Hash.new
          organization.attributes.each do |key, value|
            org[key] = value
          end
          org[:organization_name] = "<a href='#{organization_path(organization)}'>#{organization[:organization_name]}</a>"
          org[:organization_expiration_date] = organization.vendor_expiration_date
          org[:quality_rating] = organization. vendor_quality.quality_name if params[:type1].present? && params[:type2].present?
          org[:organization_email] ="<a href='mailto:#{organization.organization_email}' target='_top'>#{organization.organization_email}</a>"

          if can? :edit, Organization
            org[:links] = CommonActions.object_crud_paths(nil, edit_organization_path(organization), nil)
          else
            org[:links] = ""
          end 
           @orgs.push(org)
        }
        render json: {:aaData => @orgs}  }
    end
  end

  def mobile_api
 
      @organizations = Organization.all
      respond_to do |format|
      format.html # index.html.erb
      format.json {
 
      render json:  @organizations  }
      end

  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    @contactable = @organization
    @attachable = @organization
    @contact_type = params[:contact_type] || "address"
    
    @notes = @organization.comments.where(:comment_type => "note").order("created_at desc") if @organization 
    @tags = @organization.present? ? @organization.comments.where(:comment_type => "tag").order("created_at desc") : [] 

    respond_to do |format|
      format.html # show.html.erb
      format.json { 
        case(params[:type])
            when "min_quality"
                min_vendor_quality = @organization.min_vendor_quality.present? ? @organization.min_vendor_quality.quality_name : ""
                render json: {min_vendor_quality: min_vendor_quality}
            when "quality_level"
                quality_level = @organization.customer_quality.present? ? @organization.customer_quality : ""
                render json: {quality_level: quality_level}
            else
                render json: @organization
        end
      }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        CommonActions.notification_process("Organization", @organization)
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # organizations_path(type: @organization.organization_type.type_value)

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        CommonActions.notification_process("Organization", @organization)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end


  def populate
      @organization = Organization.find(params[:id])

      if params[:type] == "tag"
          tags = params[:tags].split(",")
          Comment.process_comments(current_user, @organization, tags, params[:type])          
      elsif params[:type] == "process"
          OrganizationProcess.process_organization_processes(current_user, @organization, params[:processes])          
      end
      redirect_to @organization
  end

  def add_comment
      @organization = Organization.find(params[:id])
      if params[:comment].present? &&  params[:type] == "note"
          Comment.process_comments(current_user, @organization, [params[:comment]], params[:type])
          note = @organization.comments.where(:comment_type => "note").order("created_at desc").first if @organization
          note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
          note["created_user"] = note.created_by.name
          note["status"] = "success"
      else
          note = Hash.new
          note["status"] = "fail"
      end

      render json: {:result => note }
  end


  def organization_info
      @organization = Organization.find(params[:id])
      if @organization
        render :layout => false
      else
        render :text => "" and return
      end
  end

  def main_address
      @organization = Organization.find(params[:organization_id])
  end
  
    
    def organization_params
      params.required(:organization).permit(:organization_expiration_date)
    end
end
