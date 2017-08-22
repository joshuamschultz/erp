class AttachmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  # GET /attachments
  # GET /attachments.json
  def index
    @attachable = params[:attachable_type].constantize.find(params[:attachable_id])
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      if params[:attachable_type] == 'QuoteVendor' && user_signed_in? && current_user.is_vendor?
        @attachments = @attachable.attachments.order('attachment_revision_date desc')
      else
        @attachments = @attachable.attachments.where(attachment_public: 1).order('attachment_revision_date desc')
      end
    else
      @attachments = @attachable.attachments.order('attachment_revision_date desc')
      # @attachments = @attachable.attachments.order("attachment_revision_date desc")
    end
    respond_to do |format|
      format.html # index.html.erb
      @atahments = []
      format.json do
        if params[:hide_info].present?
          @attachments = @attachments.select do |attachment|
            atahment = {}
            attachment.attributes.each do |key, value|
              atahment[key] = value
            end
            atahment[:attachment_name] = "<a href='#{attachment.attachment.url(:original)}' target='_blank'><i>#{attachment.attachment_name}</i></a> " if attachment.attachment
            atahment[:effective_date] = attachment.attachment_revision_date ? attachment.attachment_revision_date.strftime('%m-%d-%Y') : ''
            atahment[:uploaded_date] = attachment.created_at.strftime('%m-%d-%Y')
            atahment[:uploaded_by] = attachment.created_by ? attachment.created_by.name : ''
            atahment[:approved_by] = ''
            atahment[:links] = CommonActions.object_crud_paths(nil, edit_attachment_path(attachment), attachment_path(attachment))
            atahment[:links] += "<a href='#{attachment.attachment.url(:original)}' target='_blank' class='btn-action glyphicons file btn-success'><i></i></a> " if attachment.attachment
            @atahments.push(atahment)
          end
          render json: { aaData: @atahments }
        else
          @attachments = @attachments.select do |attachment|
            atahment = {}
            attachment.attributes.each do |key, value|
              atahment[key] = value
            end
            atahment[:attachment_name] = CommonActions.linkable(attachment_path(attachment), attachment.attachment_name)
            atahment[:effective_date] = attachment.attachment_revision_date ? attachment.attachment_revision_date.strftime('%m-%d-%Y') : ''
            atahment[:uploaded_date] = attachment.created_at.strftime('%m-%d-%Y')
            atahment[:uploaded_by] = attachment.created_by ? attachment.created_by.name : ''
            atahment[:approved_by] = ''
            atahment[:links] = CommonActions.object_crud_paths(nil, edit_attachment_path(attachment), nil)
            atahment[:links] += "<a href='#{attachment.attachment.url(:original)}' target='_blank' class='btn-action glyphicons file btn-success'><i></i></a> " if attachment.attachment
            @atahments.push(atahment)
          end
          render json: { aaData: @atahments }
        end
      end
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @attachable = params[:attachable_type].constantize.find(params[:attachable_id])
    @attachment = @attachable.attachments.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.json
  def create
    bool_saved = false
    if params[:attachment_process_type] == 'droppable'
      @attachment = Attachment.new(attachment: params[:file], attachable_id: params[:attachable_id], attachable_type: params[:attachable_type])
      CommonActions.record_ownership(@attachment, current_user)
      bool_saved = @attachment.save(validate: false)
    else
      @attachment = Attachment.new(attachment_params)
      CommonActions.record_ownership(@attachment, current_user)
      bool_saved = @attachment.save
    end

    respond_to do |format|
      if bool_saved
        format.html { redirect_to @attachment.attachable.redirect_path, notice: 'Attachment was successfully created.' }
        format.json { render json: @attachment, status: :created, location: @attachment }
      else
        format.html { render action: 'new' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])
    CommonActions.record_ownership(@attachment, current_user)

    respond_to do |format|
      if @attachment.update_attributes(attachment_params)
        CommonActions.record_ownership(@attachment, current_user)
        format.html { redirect_to @attachment.attachable.redirect_path, notice: 'Attachment was successfully updated.' }
        format.json { head :no_content }
      else
        # puts @attachment.errors.to_yaml
        format.html { render action: 'edit' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to @attachable.redirect_path }
      format.json { head :no_content }
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:attachable_id, :attachable_type, :attachment_revision_title, :attachment_revision_date,
                                       :attachment_effective_date, :attachment_name, :attachment_description, :attachment_document_type,
                                       :attachment_document_type_id, :attachment_notes, :attachment_public, :attachment_active,
                                       :attachment_status, :attachment_status_id, :attachment_created_id, :attachment_updated_id, :attachment,
                                       :attachment_file_name)
  end
end
