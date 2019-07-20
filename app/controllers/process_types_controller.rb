class ProcessTypesController < ApplicationController
  before_action :set_page_info
  before_action :set_process_type, only: %i[show edit update destroy]
  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions

  # GET /process_types
  # GET /process_types.json
  def index
    if params[:item_alt_name_id].present?
      @process_types = ProcessType.item_process_type(params[:item_alt_name_id])
    else
      @process_types = ProcessType.joins(:attachment).all
    end
    respond_to do |format|
      format.html # index.html.erb
      @proces_types = []
      format.json do
        @process_types = @process_types.collect do |process_type|
          proces_type = {}
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
        end
        render json: { aaData: @proces_types }
      end
    end
  end

  # GET /process_types/1
  # GET /process_types/1.json
  def show
    @attachment = @process_type.attachment
  end

  # GET /process_types/new
  # GET /process_types/new.json
  def new
    @process_type = ProcessType.new
    @process_type.build_attachment
  end

  # GET /process_types/1/edit
  def edit
    @attachment = @process_type.attachment
  end

  # POST /process_types
  # POST /process_types.json
  def create
    @process_type = ProcessType.new(process_type_params)

    @process_type.attachment.created_by = current_user
    if @process_type.save
      ProcessType.process_item_associations(@process_type, params)
      CommonActions.notification_process('ProcessType', @process_type)
      respond_with :process_types
    else
      respond_with @process_type
    end
  end

  # PUT /process_types/1
  # PUT /process_types/1.json
  def update
    @process_type.attachment.updated_by = current_user
    if @process_type.update_attributes(process_type_params)
      ProcessType.process_item_associations(@process_type, params)
      CommonActions.notification_process('ProcessType', @process_type)
      respond_with @process_type
    else
      respond_with @process_type
    end
  end

  # DELETE /process_types/1
  # DELETE /process_types/1.json
  def destroy
    @process_type.destroy
    respond_with :process_types
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

  def view_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, ProcessType
    end
  end

  def user_permissions
    if user_signed_in? && (current_user.is_logistics? || current_user.is_clerical?)
      authorize! :edit, ProcessType
    end
  end

  def set_page_info
    @menus[:inventory][:active] = 'active'
  end

  private

  def set_process_type
    @process_type = ProcessType.find(params[:id])
  end

  def process_type_params
    params.require(:process_type).permit(:process_active, :process_created_id, :process_description,
                                         :process_notes, :process_short_name, :process_updated_id, attachment_attributes: %i[attachable_id attachable_type attachment_revision_title attachment_revision_date
                                                                                                                             attachment_effective_date attachment_name attachment_description attachment_document_type
                                                                                                                             attachment_document_type_id attachment_notes attachment_public attachment_active
                                                                                                                             attachment_status attachment_status_id attachment_created_id attachment_updated_id attachment
                                                                                                                             attachment_file_name], notification_attributes:  %i[notable_id notable_type note_status user_id])
  end
end
