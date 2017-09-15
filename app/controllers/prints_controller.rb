class PrintsController < ApplicationController
  before_action :set_page_info
  before_action :set_print, only: %i[show edit update destroy]
  before_action :user_permissions

  autocomplete :print, :print_identifier, full: true

  # GET /prints
  # GET /prints.json
  def index
    @prints = Print.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      @prins = []
      format.json do
        @prints = @prints.collect do |print|
          prind = {}
          print.attributes.each do |key, value|
            prind[key] = value
          end
          attachment = print.attachment.attachment_fields
          print.attachment.attachment_fields.each do |key, value|
            prind[key] = value
          end
          prind[:attachment_name] = CommonActions.linkable(print_path(print), attachment[:attachment_name])
          prind[:links] = CommonActions.object_crud_paths(nil, edit_print_path(print), nil)
          @prins.push(prind)
        end
        render json: { aaData: @prins }
      end
    end
  end

  # GET /prints/1
  # GET /prints/1.json
  def show
    @attachment = @print.attachment
  end

  # GET /prints/new
  # GET /prints/new.json
  def new
    @print = Print.new
    @print.build_attachment
  end

  # GET /prints/1/edit
  def edit
    @attachment = @print.attachment
  end

  # POST /prints
  # POST /prints.json
  def create
    @print = Print.new(print_params)
    @print.attachment.created_by = current_user
    if @print.save
      CommonActions.notification_process('Print', @print)
      respond_with @print
    else
      respond_with @print
    end
  end

  # PUT /prints/1
  # PUT /prints/1.json
  def update
    @print.attachment.updated_by = current_user
    if @print.update_attributes(print_params)
      CommonActions.notification_process('Print', @print)
      respond_with @print
    else
      respond_with @print
    end
  end

  # DELETE /prints/1
  # DELETE /prints/1.json
  def destroy
    @print.destroy
    respond_with :prints
  end

  def user_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, Print
    end
  end

  def set_page_info
    @menus[:inventory][:active] = 'active'
  end

  private

  def set_print
    @print = Print.find(params[:id])
  end

  def print_params
    params.require(:print).permit(:print_active, :print_created_id, :print_description, :print_identifier,
                                  :print_notes, :print_updated_id, attachment_attributes: %i[attachable_id attachable_type attachment_revision_title attachment_revision_date
                                                                                             attachment_effective_date attachment_name attachment_description attachment_document_type
                                                                                             attachment_document_type_id attachment_notes attachment_public attachment_active
                                                                                             attachment_status attachment_status_id attachment_created_id attachment_updated_id attachment
                                                                                             attachment_file_name], notification_attributes:  %i[notable_id notable_type note_status user_id])
  end
end
