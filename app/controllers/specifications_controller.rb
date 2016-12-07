class SpecificationsController < ApplicationController
  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
      authorize! :edit, Specification
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? )
      authorize! :edit, Specification
    end
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  # GET /specifications
  # GET /specifications.json
  def index
    if params[:item_id].present?
      @specifications =Specification.item_specification(params[:item_id])
    else
      @specifications = Specification.joins(:attachment).all
    end
    respond_to do |format|
      format.html # index.html.erb
      @specificasions = Array.new
      format.json {
        @specifications = @specifications.collect{|specification|
          specificasion = Hash.new
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
        }
        render json: {:aaData => @specificasions}
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
    @attachment = @specification.attachment

  end

  # POST /specifications
  # POST /specifications.json
  def create
    @specification = Specification.new(specification_params)

    respond_to do |format|
      @specification.attachment.created_by = current_user
      if @specification.save
        CommonActions.notification_process("Specification", @specification)
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
        CommonActions.notification_process("Specification", @specification)
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
  private

    def set_specification
      @specification = Specification.find(params[:id])
    end

    def specification_params
      params.require(:specification).permit(:specification_active, :specification_created_id, :specification_description,
                                            :specification_identifier, :specification_notes, :specification_updated_id, attachment_attributes: [:attachable_id, :attachable_type, :attachment_revision_title, :attachment_revision_date,
                                         :attachment_effective_date, :attachment_name, :attachment_description, :attachment_document_type,
                                         :attachment_document_type_id, :attachment_notes, :attachment_public, :attachment_active,
                                         :attachment_status, :attachment_status_id, :attachment_created_id, :attachment_updated_id, :attachment,
                                         :attachment_file_name], notification_attributes:  [:notable_id, :notable_type, :note_status, :user_id])
    end
end
