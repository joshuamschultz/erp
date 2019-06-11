class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  before_action :set_record, only: %i[delete_comment add_comment]

  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  def add_comment
    if params[:comment].present? && params[:type] == "note"
      Comment.process_comments(current_user, @record, [params[:comment]], params[:type])
      @notes = @record.comments.where(comment_type: "note").order("created_at desc") if @record
      respond_to do |format|
        format.js { render "comment.js.erb" }
      end
    end
  end

  def delete_comment
    Comment.where(id: params[:id]).first.destroy!
    @notes = @record.comments.where(comment_type: "note").order("created_at desc") if @record
    respond_to do |format|
      format.js { render "comment.js.erb" }
    end
  end

  private

  def set_record
    @record = if params[:organization_id].present?
      Organization.find params[:organization_id]
    elsif params[:po_header_id].present?
      PoHeader.find params[:po_header_id]
    elsif params[:so_header_id].present?
      SoHeader.find params[:so_header_id]
    elsif params[:quality_lot_id].present?
      QualityLot.find params[:quality_lot_id]
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment, :comment_active, :comment_created_id, :comment_updated_id,
    :commentable_id, :commentable_type, :comment_type)
  end
end
