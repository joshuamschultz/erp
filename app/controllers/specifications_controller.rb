class SpecificationsController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:inventory][:active] = "active"
  end
  
  # GET /specifications
  # GET /specifications.json
  def index
    @specifications = Specification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @specifications = @specifications.select{|specification| 
          specification[:links] = CommonActions.object_crud_paths(specification_path(specification), edit_specification_path(specification), 
                        specification_path(specification))
        }
        render json: {:aaData => @specifications} 
      }
    end
  end

  # GET /specifications/1
  # GET /specifications/1.json
  def show
    @specification = Specification.find(params[:id])
    @object = @specification

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @specification }
    end
  end

  # GET /specifications/new
  # GET /specifications/new.json
  def new
    @specification = Specification.new

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
