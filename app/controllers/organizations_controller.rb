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
   if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, Organization
    end 
  end

  def set_page_info
    unless user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
      @menus[:contacts][:active] = "active"
    end
  end

  def get_autocomplete_items(parameters)
    items = super(parameters)    
    items = items.organizations(params[:type])
  end

  # GET /organizations
  # GET /organizations.json
  def index
    if params[:type]
        @org_type = MasterType.find_by_type_value(params[:type])
        @organizations = @org_type.type_based_organizations
    else
        @organizations = Organization.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @organizations = @organizations.select{|organization| 
          organization[:organization_name] = "<a href='#{organization_path(organization)}'>#{organization[:organization_name]}</a>"
          if can? :edit, Organization
            organization[:links] = CommonActions.object_crud_paths(nil, edit_organization_path(organization), nil)
           else
             organization[:links] = ""
           end 
        }
        render json: {:aaData => @organizations}  }
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


end
