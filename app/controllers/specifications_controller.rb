class SpecificationsController < ApplicationController
  before_action :set_specification, %i[show edit update destroy]
  before_action :set_page_info
  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions

  # GET /specifications
  # GET /specifications.json
  def index
    # if there is an item in the params, show those specs for the item.
    # Otherwise grab all specs in the system
    if params[:item_id].present?
      @specifications = Specification.item_specification(params[:item_id])
    else
      @specifications = Specification.joins(:attachment).all
    end
    respond_to do |format|
      format.html # index.html.erb
      @specificasions = []
      format.json do
        @specifications = @specifications.collect do |specification|
          specificasion = {}
          specification.attributes.each do |key, value|
            specificasion[key] = value
          end
          attachment = specification.attachment.attachment_fields
          specification.attachment.attachment_fields.each do |key, value|
            specificasion[key] = value
          end
          specificasion[:attachment_name] = CommonActions.linkable(specification_path(specification), attachment[:attachment_name])
          if can? :edit, specification
            specificasion[:links] = CommonActions.object_crud_paths(nil, edit_specification_path(specification), nil)
          else
            specificasion[:links] = nil
          end

          @specificasions.push(specificasion)
        end
        render json: { aaData: @specificasions }
      end
    end
  end

  # GET /specifications/1
  # GET /specifications/1.json
  def show
    @attachment = @specification.attachment
  end

  # GET /specifications/new
  # GET /specifications/new.json
  def new
    @specification = Specification.new
    @specification.build_attachment
  end

  # GET /specifications/1/edit
  def edit
    @attachment = @specification.attachment
  end

  # POST /specifications
  # POST /specifications.json
  def create
    @specification = Specification.new(specification_params)

    respond_to do |format|
      @specification.attachment.created_by = current_user
      if @specification.save
        CommonActions.notification_process('Specification', @specification)
        format.html { redirect_to specifications_url, notice: 'Specification was successfully created.' }
        format.json { render json: @specification, status: :created, location: @specification }
      else
        format.html { render action: 'new' }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /specifications/1
  # PUT /specifications/1.json
  def update
    respond_to do |format|
      @specification.attachment.updated_by = current_user
      if @specification.update_attributes(specification_params)
        CommonActions.notification_process('Specification', @specification)
        format.html { redirect_to specifications_url, notice: 'Specification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specifications/1
  # DELETE /specifications/1.json
  def destroy
    @specification.destroy
    respond_with :specifications
  end

  def view_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, Specification
    end
  end

  def user_permissions
    if user_signed_in? && (current_user.is_logistics? || current_user.is_clerical?)
      authorize! :edit, Specification
    end
  end

  def set_page_info
    @menus[:inventory][:active] = 'active'
  end

  private

  def set_specification
    @specification = Specification.find(params[:id])
  end

  def specification_params
    params.require(:specification).permit(:specification_active, :specification_created_id, :specification_description,
                                          :specification_identifier, :specification_notes, :specification_updated_id, attachment_attributes: %i[attachable_id attachable_type attachment_revision_title attachment_revision_date
                                                                                                                                                attachment_effective_date attachment_name attachment_description attachment_document_type
                                                                                                                                                attachment_document_type_id attachment_notes attachment_public attachment_active
                                                                                                                                                attachment_status attachment_status_id attachment_created_id attachment_updated_id attachment
                                                                                                                                                attachment_file_name], notification_attributes:  %i[notable_id notable_type note_status user_id])
  end
end
