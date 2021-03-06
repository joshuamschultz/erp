class CustomerFeedbacksController < ApplicationController
    before_action :set_autocomplete_values, only: [:create, :update]
    before_action :set_page_info
    before_action :user_permissions

    def user_permissions
      if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
          authorize! :edit, CustomerFeedback
      end
    end

    def set_page_info
      @menus[:quality][:active] = "active"
    end

    def set_autocomplete_values
      params[:customer_feedback][:organization_id], params[:organization_id] = params[:organization_id], params[:customer_feedback][:organization_id]
      params[:customer_feedback][:organization_id] = params[:org_organization_id] if params[:customer_feedback][:organization_id] == ""

      params[:customer_feedback][:quality_action_id], params[:quality_action_id] = params[:quality_action_id], params[:customer_feedback][:quality_action_id]
      params[:customer_feedback][:quality_action_id] = params[:org_quality_action_id] if params[:customer_feedback][:quality_action_id] == ""
    end
  # GET /customer_feedbacks
  # GET /customer_feedbacks.json
  def index
    @customer_feedbacks = CustomerFeedback.all
    respond_to do |format|
      format.html # index.html.erb
      @customer_fedbacks = Array.new
      format.json {  @customer_feedbacks = @customer_feedbacks.select{|customer_feedback|
                    customer_fedback = Hash.new
                    customer_feedback.attributes.each do |key, value|
                      customer_fedback[key] = value
                    end
                    customer_fedback[:title] = CommonActions.linkable(customer_feedback_path(customer_feedback), customer_feedback.title)
                    customer_fedback[:organization_feed] = customer_feedback.organization.organization_name
                    customer_fedback[:created] = customer_feedback.created_at.strftime("%d %b %Y")
                    customer_fedback[:user_feed] = customer_feedback.user.name
                    customer_fedback[:links] = CommonActions.object_crud_paths(nil, edit_customer_feedback_path(customer_feedback), nil)
                    @customer_fedbacks.push(customer_fedback)
                 }
                 render json: {:aaData => @customer_fedbacks}
                 }
    end
  end

  # GET /customer_feedbacks/1
  # GET /customer_feedbacks/1.json
  def show
    @customer_feedback = CustomerFeedback.find(params[:id])
    @attachable = @customer_feedback
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_feedback }
    end
  end

  # GET /customer_feedbacks/new
  # GET /customer_feedbacks/new.json
  def new
    @customer_feedback = CustomerFeedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_feedback }
    end
  end

  # GET /customer_feedbacks/1/edit
  def edit
    @customer_feedback = CustomerFeedback.find(params[:id])
  end

  # POST /customer_feedbacks
  # POST /customer_feedbacks.json
  def create
    @customer_feedback = CustomerFeedback.new(customer_feedback_params)
    @customer_feedback[:user_id] = current_user.id

    respond_to do |format|
      if @customer_feedback.save
        format.html { redirect_to @customer_feedback, notice: 'Customer feedback was successfully created.' }
        format.json { render json: @customer_feedback, status: :created, location: @customer_feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customer_feedbacks/1
  # PUT /customer_feedbacks/1.json
  def update
    @customer_feedback = CustomerFeedback.find(params[:id])

    respond_to do |format|
      if @customer_feedback.update_attributes(customer_feedback_params)
        format.html { redirect_to @customer_feedback, notice: 'Customer feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_feedbacks/1
  # DELETE /customer_feedbacks/1.json
  def destroy
    @customer_feedback = CustomerFeedback.find(params[:id])
    @customer_feedback.destroy

    respond_to do |format|
      format.html { redirect_to customer_feedbacks_url }
      format.json { head :no_content }
    end
  end
  private

    def set_customer_feedback
      @customer_feedback = CustomerFeedback.find(params[:id])
    end

    def customer_feedback_params
      params.require(:customer_feedback).permit(:feedback, :quality_action_id, :title, :organization_id, :user_id, :customer_feedback_type_id)
    end
end
