class OrganizationsController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:system][:active] = "active"
  end

  # GET /organizations
  # GET /organizations.json
  def index
    @org_type = MasterType.find_by_type_value(params[:type] ||= "customer")
    @organizations = @org_type.type_based_organizations

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @organizations = @organizations.select{|organization| 
          organization[:links] = CommonActions.object_crud_paths(organization_path(organization), edit_organization_path(organization), 
                        organization_path(organization))
        }
        render json: {:aaData => @organizations}  }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    redirect_to organizations_path
    # @organization = Organization.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @organization }
    # end
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
        format.html { redirect_to organizations_path(type: @organization.organization_type.type_value), notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to organizations_path(type: @organization.organization_type.type_value), notice: 'Organization was successfully updated.' }
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
end
