class ProcessFlowsController < ApplicationController
  before_filter :set_page_info

  autocomplete :process_flow, :process_name, :full => true

  def set_page_info
    @menus[:quality][:active] = "active"
  end

  # GET /process_flows
  # GET /process_flows.json
  def index
    @process_flows = ProcessFlow.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @process_flows = @process_flows.collect{|process_flow| 
        attachment = process_flow.attachment.attachment_fields
        attachment[:attachment_name] = CommonActions.linkable(process_flow_path(process_flow), attachment.attachment_name)
        attachment[:links] = CommonActions.object_crud_paths(nil, edit_process_flow_path(process_flow), nil)
        attachment
        }
        render json: { :aaData => @process_flows } 
      }
    end
  end

  # GET /process_flows/1
  # GET /process_flows/1.json
  def show
    @process_flow = ProcessFlow.find(params[:id])
    @attachment = @process_flow.attachment
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @process_flow }
    end
  end

  # GET /process_flows/new
  # GET /process_flows/new.json
  def new
    @process_flow = ProcessFlow.new
    @process_flow.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @process_flow }
    end
  end

  # GET /process_flows/1/edit
  def edit
    @process_flow = ProcessFlow.find(params[:id])
    @attachment = @process_flow.attachment
  end

  # POST /process_flows
  # POST /process_flows.json
  def create
    @process_flow = ProcessFlow.new(params[:process_flow])

    respond_to do |format|
      @process_flow.attachment.created_by = current_user   
      if @process_flow.save
        format.html { redirect_to process_flows_url, notice: 'Process flow was successfully created.' }
        format.json { render json: @process_flow, status: :created, location: @process_flow }
      else
        format.html { render action: "new" }
        format.json { render json: @process_flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /process_flows/1
  # PUT /process_flows/1.json
  def update
    @process_flow = ProcessFlow.find(params[:id])

    respond_to do |format|
      @process_flow.attachment.updated_by = current_user
      if @process_flow.update_attributes(params[:process_flow])
        format.html { redirect_to process_flows_url, notice: 'Process flow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @process_flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_flows/1
  # DELETE /process_flows/1.json
  def destroy
    @process_flow = ProcessFlow.find(params[:id])
    @process_flow.destroy

    respond_to do |format|
      format.html { redirect_to process_flows_url }
      format.json { head :no_content }
    end
  end
end
