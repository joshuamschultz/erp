class AttachmentsController < ApplicationController
  # GET /attachments
  # GET /attachments.json
  def index
    @attachable = params[:attachable_type].constantize.find(params[:attachable_id])
    @attachments = @attachable.attachments.order("attachment_revision_date desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @attachments = @attachments.select{|attachment|
              attachment[:attachment_name] = CommonActions.linkable(attachment_path(attachment), attachment.attachment_name)
              attachment[:effective_date] = attachment.attachment_revision_date ? attachment.attachment_revision_date.strftime("%m-%d-%Y") : ""
              attachment[:uploaded_date] = attachment.created_at.strftime("%m-%d-%Y")
              attachment[:uploaded_by] = attachment.created_by ? attachment.created_by.name : "" 
              attachment[:approved_by] = ""
              attachment[:links] = CommonActions.object_crud_paths(nil, edit_attachment_path(attachment), nil)
              attachment[:links] += "<a href='#{attachment.attachment.url(:original)}' target='_blank' class='btn-action glyphicons file btn-success'><i></i></a> "
            }
          render json: {:aaData => @attachments} 
      }
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
    @attachment = Attachment.new(params[:attachment])
    CommonActions.record_ownership(@attachment, current_user)

    respond_to do |format|
      if @attachment.save        
        format.html { redirect_to @attachment.attachable.redirect_path, notice: 'Attachment was successfully created.' }
        format.json { render json: @attachment, status: :created, location: @attachment }
      else
        puts @attachment.errors.to_yaml
        format.html { render action: "new" }
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
      if @attachment.update_attributes(params[:attachment])
        CommonActions.record_ownership(@attachment, current_user) 
        format.html { redirect_to @attachment.attachable.redirect_path, notice: 'Attachment was successfully updated.' }
        format.json { head :no_content }
      else
        puts @attachment.errors.to_yaml
        format.html { render action: "edit" }
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
end
