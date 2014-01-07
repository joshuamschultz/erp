class GlTypesController < ApplicationController
  before_filter :set_page_info

  def set_page_info
    @menus[:general_ledger][:active] = "active"
  end

  # GET /gl_types
  # GET /gl_types.json
  def index
    @gl_types = GlType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @gl_types = @gl_types.select{|gl_type| 
            gl_type[:links] = CommonActions.object_crud_paths(nil, edit_gl_type_path(gl_type), gl_type_path(gl_type))
          }
          render json: {:aaData => @gl_types}
      }
    end
  end

  # GET /gl_types/1
  # GET /gl_types/1.json
  def show
    @gl_type = GlType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gl_type }
    end
  end

  # GET /gl_types/new
  # GET /gl_types/new.json
  def new
    @gl_type = GlType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gl_type }
    end
  end

  # GET /gl_types/1/edit
  def edit
    @gl_type = GlType.find(params[:id])
  end

  # POST /gl_types
  # POST /gl_types.json
  def create
    @gl_type = GlType.new(params[:gl_type])

    respond_to do |format|
      if @gl_type.save
        format.html { redirect_to gl_types_path, notice: 'Gl type was successfully created.' }
        format.json { render json: @gl_type, status: :created, location: @gl_type }
      else
        format.html { render action: "new" }
        format.json { render json: @gl_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gl_types/1
  # PUT /gl_types/1.json
  def update
    @gl_type = GlType.find(params[:id])

    respond_to do |format|
      if @gl_type.update_attributes(params[:gl_type])
        format.html { redirect_to gl_types_path, notice: 'Gl type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gl_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gl_types/1
  # DELETE /gl_types/1.json
  def destroy
    @gl_type = GlType.find(params[:id])
    @gl_type.destroy

    respond_to do |format|
      format.html { redirect_to gl_types_url }
      format.json { head :no_content }
    end
  end
end
