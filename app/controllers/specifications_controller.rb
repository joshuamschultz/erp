class SpecificationsController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:inventory][:active] = "active"
  end
  
  # GET /specifications
  # GET /specifications.json
  def index
    @specifications = Specification.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @specifications = @specifications.collect{|specification| 
          attachment = specification.attachment.attachment_fields
          # attachment[:attachment_name] = CommonActions.linkable(specification_path(specification), attachment.attachment_name)
          attachment[:links] = CommonActions.object_crud_paths(nil, edit_specification_path(specification), nil)
          attachment
        }
        render json: {:aaData => @specifications} 
      }
    end
  end

  # GET /specifications/1
  # GET /specifications/1.json
  def show
    @specification = Specification.find(params[:id])
    @attachment = @specification.attachment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @specification }
    end
  end

  # GET /specifications/new
  # GET /specifications/new.json
  def new
    @specification = Specification.new
    @specification.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @specification }
    end
  end

  # GET /specifications/1/edit
  def edit
    @specification = Specification.find(params[:id])
  end

  # POST /specifications
  # POST /specifications.json
  def create
    @specification = Specification.new(params[:specification])

    respond_to do |format|
      @specification.attachment.created_by = current_user
      if @specification.save
        format.html { redirect_to specifications_url, notice: 'Specification was successfully created.' }
        format.json { render json: @specification, status: :created, location: @specification }
      else
        format.html { render action: "new" }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /specifications/1
  # PUT /specifications/1.json
  def update
    @specification = Specification.find(params[:id])

    respond_to do |format|
      @specification.attachment.updated_by = current_user
      if @specification.update_attributes(params[:specification])
        format.html { redirect_to specifications_url, notice: 'Specification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specifications/1
  # DELETE /specifications/1.json
  def destroy
    @specification = Specification.find(params[:id])
    @specification.destroy

    respond_to do |format|
      format.html { redirect_to specifications_url }
      format.json { head :no_content }
    end
  end
end
