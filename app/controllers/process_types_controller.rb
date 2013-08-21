class ProcessTypesController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:inventory][:active] = "active"
  end
  # GET /process_types
  # GET /process_types.json
  def index
    @process_types = ProcessType.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @process_types = @process_types.collect{|process_type| 
          attachment = process_type.attachment.attachment_fields
          attachment[:attachment_name] = CommonActions.linkable(process_type_path(process_type), attachment.attachment_name)
          attachment[:links] = CommonActions.object_crud_paths(nil, edit_process_type_path(process_type), nil)
          attachment
        }
        render json: {:aaData => @process_types} 
      }
    end
  end

  # GET /process_types/1
  # GET /process_types/1.json
  def show
    @process_type = ProcessType.find(params[:id])
    @attachment = @process_type.attachment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @process_type }
    end
  end

  # GET /process_types/new
  # GET /process_types/new.json
  def new
    @process_type = ProcessType.new
    @process_type.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @process_type }
    end
  end

  # GET /process_types/1/edit
  def edit
    @process_type = ProcessType.find(params[:id])
  end

  # POST /process_types
  # POST /process_types.json
  def create
    @process_type = ProcessType.new(params[:process_type])

    respond_to do |format|
      @process_type.attachment.created_by = current_user
      if @process_type.save
        format.html { redirect_to process_types_url, notice: 'Process type was successfully created.' }
        format.json { render json: @process_type, status: :created, location: @process_type }
      else
        format.html { render action: "new" }
        format.json { render json: @process_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /process_types/1
  # PUT /process_types/1.json
  def update
    @process_type = ProcessType.find(params[:id])

    respond_to do |format|
      @process_type.attachment.updated_by = current_user
      if @process_type.update_attributes(params[:process_type])
        format.html { redirect_to process_types_url, notice: 'Process type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @process_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_types/1
  # DELETE /process_types/1.json
  def destroy
    @process_type = ProcessType.find(params[:id])
    @process_type.destroy

    respond_to do |format|
      format.html { redirect_to process_types_url }
      format.json { head :no_content }
    end
  end
end
