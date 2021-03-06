class QualityActionsController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]

  autocomplete :quality_action, :quality_action_no, :full => true

  before_action :view_permissions, except: [:index, :show]

  before_action :user_permissions

  def view_permissions
    if  user_signed_in? && ( current_user.is_operations? || current_user.is_logistics? )
        authorize! :edit, QualityAction
    end
  end

  def user_permissions
    if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, QualityAction
    end
  end


  def set_page_info
      @menus[:quality][:active] = "active"
      # simple_form_validation = false
  end

  def set_autocomplete_values
    params[:quality_action][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:quality_action][:item_alt_name_id]
    params[:quality_action][:item_alt_name_id] = params[:org_alt_name_id] if params[:quality_action][:item_alt_name_id] == "" || params[:quality_action][:item_alt_name_id].nil?

    params[:quality_action][:po_header_id], params[:po_header_id] = params[:po_header_id], params[:quality_action][:po_header_id]
    params[:quality_action][:po_header_id] = params[:org_po_header_id] if params[:quality_action][:po_header_id] == ""


    params[:quality_action][:cause_analysis_id], params[:cause_analysis_id] = params[:cause_analysis_id], params[:quality_action][:cause_analysis_id]
    params[:quality_action][:cause_analysis_id] = params[:org_cause_analysis_id] if params[:quality_action][:cause_analysis_id] == ""
  end
  # GET /quality_actions
  # GET /quality_actions.json
  def index
    if  user_signed_in? && (current_user.is_operations? || current_user.is_logistics? || current_user.is_vendor? || current_user.is_customer? )

      if params[:status]

        @quality_actions = QualityAction.quality_action_filtering_status(params[:status])
        @quality_actions = QualityAction.status_based_quality_action(params[:status])
        @status = params[:status]
      else
        @quality_actions = QualityAction.quality_action_filtering
      end

    else

      if params[:status]
        @quality_actions = QualityAction.status_based_quality_action(params[:status])
        @status = params[:status]
      else
        @quality_actions = QualityAction.all
      end

    end




    respond_to do |format|
      format.html # index.html.erb
      @quality_actins = Array.new
      format.json {
         @quality_actions = @quality_actions.select{|quality_action|
            quality_actin = Hash.new
            quality_action.attributes.each do |key, value|
              quality_actin[key] = value
            end
            quality_actin[:created_user] = quality_action.created_user.present? ? quality_action.created_user.name : ""

            if (can? :edit , quality_action)
              quality_actin[:links] = quality_action.get_link
            else
              quality_actin[:links] = nil
            end
            quality_actin[:user] = quality_action.created_user.present? ? quality_action.created_user.name : ""
            quality_actin[:action_no] = CommonActions.linkable(quality_action_path(quality_action), quality_action.quality_action_no)
            quality_actin[:status_action] = CommonActions.set_quality_status(quality_action.quality_action_status)
            @quality_actins.push(quality_actin)

        }
        render json: {:aaData => @quality_actins}
      }
    end
  end

  # GET /quality_actions/1
  # GET /quality_actions/1.json
  def show
    @quality_action = QualityAction.find(params[:id])
    @attachable = @quality_action

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_action }
    end
  end

  # GET /quality_actions/new
  # GET /quality_actions/new.json
  def new
    @quality_action = QualityAction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_action }
    end
  end

  # GET /quality_actions/1/edit
  def edit
    @quality_action = QualityAction.find(params[:id])
    redirect_to quality_actions_path if @quality_action.quality_action_status == "finished" && @quality_action.updated_at.to_date != Date.today
  end

  # POST /quality_actions
  # POST /quality_actions.json
  def create
    if params[:finish]
      @quality_action = QualityAction.new(quality_action_params)
      @quality_action[:quality_action_status] = "finished"
      @quality_action[:submit_time] = Time.now

    elsif params[:save]
      @quality_action = QualityAction.new(quality_action_params)
      @quality_action[:quality_action_status] = "open"
    end
      @quality_action[:created_user_id] = current_user.id

    respond_to do |format|
      if @quality_action.save
        @quality_action.set_user(params)
        CommonActions.notification_process("QualityAction", @quality_action)
        format.html { redirect_to quality_action_path(@quality_action), notice: 'Quality action was successfully created.' }
        format.json { render json: @quality_action, status: :created, location: @quality_action }
      else
        p @quality_action.errors
        format.html { render action: "new" }
        format.json { render json: @quality_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_actions/1
  # PUT /quality_actions/1.json
  def update
    if params[:finish]
      @quality_action = QualityAction.find(params[:id])
      @quality_action[:quality_action_status] = "finished"
      @quality_action[:submit_time] = Time.now
    elsif params[:save]
      @quality_action = QualityAction.find(params[:id])
      @quality_action[:quality_action_status] = "open"
    end

    respond_to do |format|
      if @quality_action.update_attributes(quality_action_params)
         @quality_action.set_user(params)
        CommonActions.notification_process("QualityAction", @quality_action)
        format.html { redirect_to quality_actions_url, notice: 'Quality action was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_actions/1
  # DELETE /quality_actions/1.json
  def destroy
    @quality_action = QualityAction.find(params[:id])
    @quality_action.destroy

    respond_to do |format|
      format.html { redirect_to quality_actions_url }
      format.json { head :no_content }
    end
  end

  def quality_report
    @quality_action = QualityAction.find(params[:id])
      render :layout => false

  end
   private

    def set_quality_action
      @quality_action = QualityAction.find(params[:id])
    end

    def quality_action_params
      params.require(:quality_action).permit(:definition_of_issue, :due_date, :ic_action_id, :organization_quality_type_id, :quality_action_active,
                                             :quality_action_no, :quality_action_status, :quantity, :required_action, :short_term_fix, :submit_time,
                                             :item_id, :item_alt_id, :item_revision_id, :cause_analysis_id, :po_header_id, :item_alt_name_id,
                                             :created_user_id, :root_cause, :quality_lot_id, :notification_attributes)
    end
end
