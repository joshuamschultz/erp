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
    @organization = Organization.find(params[:id])
    @notes = @organization.comments.where(:comment_type => "note").order("created_at desc") if @organization 
    @tags = @organization.comments.where(:comment_type => "tag").order("created_at desc") if @organization 

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
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


  def comment
      @organization = Organization.find(params[:id])

      if params[:type] == "tag"
          @organization.comments.where(:comment_type => "tag").destroy_all
          tags = params[:tags].split(",")          
          tags.each do |tag|
              process_organization_comments(tag, params[:type])
          end
          
      elsif params[:type] == "note"
          process_organization_comments(params[:comment], params[:type])
      end

      redirect_to @organization
  end

  private

  def process_organization_comments(comment, type)
      comment = @organization.comments.new(:comment => comment, :comment_type => type)
      comment = CommonActions.record_ownership(comment, current_user) 
      comment.save
  end

end
