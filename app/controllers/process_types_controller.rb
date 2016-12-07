class ProcessTypesController < ApplicationController
  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
      authorize! :edit, ProcessType
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? )
      authorize! :edit, ProcessType
    end
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
  end
  # GET /process_types
  # GET /process_types.json
  def index
    if params[:item_id].present?
      @process_types =ProcessType.item_process_type(params[:item_id])
    else
      @process_types = ProcessType.joins(:attachment).all
    end
    respond_to do |format|
      format.html # index.html.erb
      @proces_types = Array.new
      format.json {
        @process_types = @process_types.collect{|process_type|
          proces_type = Hash.new
          process_type.attributes.each do |key, value|
            proces_type[key] = value
          end
          attachment = process_type.attachment.attachment_fields
          process_type.attachment.attachment_fields.each do |key, value|
            proces_type[key] = value
          end
          proces_type[:attachment_name] = CommonActions.linkable(process_type_path(process_type), attachment[:attachment_name])
          if can? :edit, ProcessType
            proces_type[:links] = CommonActions.object_crud_paths(nil, edit_process_type_path(process_type), nil)
          else
            proces_type[:links] = ''
          end
          @proces_types.push(proces_type)
        }
        render json: {:aaData => @proces_types}
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
    @attachment = @process_type.attachment
  end

  # POST /process_types
  # POST /process_types.json
  def create
    @process_type = ProcessType.new(process_type_params)

    respond_to do |format|
      @process_type.attachment.created_by = current_user
      if @process_type.save
        ProcessType.process_item_associations(@process_type, params)
        CommonActions.notification_process("ProcessType", @process_type)
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
      if @process_type.update_attributes(process_type_params)
        ProcessType.process_item_associations(@process_type, params)
        CommonActions.notification_process("ProcessType", @process_type)
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

  # def process_specs
  #   if params[:item_id].present? && params[:process_types].present?
  #        @process_types =ProcessType.item_process_type(params[:item_id])
  #        @specifications = ProcessType.process_type_specifications(@process_types)
  #   end
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json {
  #       @specifications = @specifications.collect{|specification|
  #         attachment = specification.attachment
  #         attachment[:attachment_name] = CommonActions.linkable(specification_path(specification), attachment.attachment_name)
  #         attachment[:attachment_revision] = attachment.attachment_revision_title
  #         attachment[:uploaded_by] = attachment.created_by ? attachment.created_by.name : ""
  #         attachment[:attachment_public] = attachment.attachment_public
  #         attachment[:effective_date] = attachment.attachment_revision_date ? attachment.attachment_revision_date.strftime("%m-%d-%Y") : ""
  #         attachment[:links] = CommonActions.object_crud_paths(nil, edit_specification_path(specification), nil)
  #         attachment
  #       }
  #       render json: {:aaData => @specifications}
  #     }
  #   end
  # end
   private

    def set_process_type
      @process_type = ProcessType.find(params[:id])
    end

    def process_type_params
      params.require(:process_type).permit(:process_active, :process_created_id, :process_description,
                                           :process_notes, :process_short_name, :process_updated_id, attachment_attributes: [:attachable_id, :attachable_type, :attachment_revision_title, :attachment_revision_date,
                                         :attachment_effective_date, :attachment_name, :attachment_description, :attachment_document_type,
                                         :attachment_document_type_id, :attachment_notes, :attachment_public, :attachment_active,
                                         :attachment_status, :attachment_status_id, :attachment_created_id, :attachment_updated_id, :attachment,
                                         :attachment_file_name], notification_attributes:  [:notable_id, :notable_type, :note_status, :user_id])
    end
end
