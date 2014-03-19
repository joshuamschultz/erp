class GroupOrganizationsController < ApplicationController
  # GET /group_organizations
  # GET /group_organizations.json
  def index
    @group_organizations = GroupOrganization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @group_organizations }
    end
  end

  # GET /group_organizations/1
  # GET /group_organizations/1.json
  def show
    @group_organization = GroupOrganization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group_organization }
    end
  end

  # GET /group_organizations/new
  # GET /group_organizations/new.json
  def new
    @group_organization = GroupOrganization.new
    @group = Group.find(params[:group_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group_organization }
    end
  end

  # GET /group_organizations/1/edit
  def edit
    @group_organization = GroupOrganization.find(params[:id])
  end

  # POST /group_organizations
  # POST /group_organizations.json
  def create
    @group_organization = GroupOrganization.new(params[:group_organization])

    respond_to do |format|
      if @group_organization.save
        format.html { redirect_to @group_organization, notice: 'Group organization was successfully created.' }
        format.json { render json: @group_organization, status: :created, location: @group_organization }
      else
        format.html { render action: "new" }
        format.json { render json: @group_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /group_organizations/1
  # PUT /group_organizations/1.json
  def update
    @group_organization = GroupOrganization.find(params[:id])

    respond_to do |format|
      if @group_organization.update_attributes(params[:group_organization])
        format.html { redirect_to @group_organization, notice: 'Group organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_organizations/1
  # DELETE /group_organizations/1.json
  def destroy
    @group_organization = GroupOrganization.find(params[:id])
    @group_organization.destroy

    respond_to do |format|
      format.html { redirect_to group_organizations_url }
      format.json { head :no_content }
    end
  end
end