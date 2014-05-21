class QualityActionsController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]

  autocomplete :quality_action, :quality_action_no, :full => true


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
    if params[:status]
      @quality_actions = QualityAction.status_based_quality_action(params[:status])
      @status = params[:status]
    else
      @quality_actions = QualityAction.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
         @quality_actions = @quality_actions.select{|quality_action|
            quality_action[:created_user] = quality_action.created_user.present? ? quality_action.created_user.name : ""
            quality_action[:links] = CommonActions.object_crud_paths(nil, edit_quality_action_path(quality_action),nil)
            quality_action[:user] =  quality_action.created_user.present? ? quality_action.created_user.name : ""
            quality_action[:action_no] = CommonActions.linkable(quality_action_path(quality_action), quality_action.quality_action_no)
            quality_action[:status_action] = CommonActions.set_quality_status(quality_action.quality_action_status)

        }
        render json: {:aaData => @quality_actions}
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
  end

  # POST /quality_actions
  # POST /quality_actions.json
  def create
    if params[:finish]
      @quality_action = QualityAction.new(params[:quality_action])
      @quality_action[:quality_action_status] = "finished"
      @quality_action[:submit_time] = Time.now     

    elsif params[:save]
      @quality_action = QualityAction.new(params[:quality_action])
      @quality_action[:quality_action_status] = "open"
    end
      @quality_action[:created_user_id] = current_user.id

    respond_to do |format|
      if @quality_action.save
        @quality_action.set_user(params)
        format.html { redirect_to quality_actions_url, notice: 'Quality action was successfully created.' }
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
    end



    respond_to do |format|
      if @quality_action.update_attributes(params[:quality_action])
         @quality_action.set_user(params)

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
end
