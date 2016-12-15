class CapacityPlanningsController < ApplicationController
    before_action :set_page_info
  autocomplete :capacity_planning, :capacity_plan_name, :full => true
  def set_page_info
    @menus[:quality][:active] = "active"
  end
  # GET /capacity_plannings
  # GET /capacity_plannings.json
  def index
    @capacity_plannings = CapacityPlanning.joins(:attachment).all


    respond_to do |format|
      format.html # index.html.erb
      format.json {
          @capacity_plannings = @capacity_plannings.collect{|capacity_planning|
          attachment = capacity_planning.attachment.attachment_fields
          attachment[:attachment_name] = CommonActions.linkable(capacity_planning_path(capacity_planning), attachment[:attachment_name])
          attachment[:links] = CommonActions.object_crud_paths(nil, edit_capacity_planning_path(capacity_planning), nil)
          attachment
        }
        render json: {:aaData => @capacity_plannings}
      }
    end
  end

  # GET /capacity_plannings/1
  # GET /capacity_plannings/1.json
  def show
    @capacity_planning = CapacityPlanning.find(params[:id])
    @attachment = @capacity_planning.attachment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @capacity_planning }
    end
  end

  # GET /capacity_plannings/new
  # GET /capacity_plannings/new.json
  def new
    @capacity_planning = CapacityPlanning.new
    @capacity_planning.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @capacity_planning }
    end
  end

  # GET /capacity_plannings/1/edit
  def edit
    @capacity_planning = CapacityPlanning.find(params[:id])
    @attachment = @capacity_planning.attachment

  end

  # POST /capacity_plannings
  # POST /capacity_plannings.json
  def create
    @capacity_planning = CapacityPlanning.new(capacity_planning_params)
    p @capacity_planning.attachment
    respond_to do |format|
      @capacity_planning.attachment.created_by = current_user

      if @capacity_planning.save
        format.html { redirect_to capacity_plannings_url, notice: 'Capacity planning was successfully created.' }
        format.json { render json: @capacity_planning, status: :created, location: @capacity_planning }
      else
        format.html { render action: "new" }
        format.json { render json: @capacity_planning.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /capacity_plannings/1
  # PUT /capacity_plannings/1.json
  def update
    @capacity_planning = CapacityPlanning.find(params[:id])

    respond_to do |format|
      @capacity_planning.attachment.updated_by = current_user
      if @capacity_planning.update_attributes(capacity_planning_params)
        format.html { redirect_to capacity_plannings_url, notice: 'Capacity planning was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @capacity_planning.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capacity_plannings/1
  # DELETE /capacity_plannings/1.json
  def destroy
    @capacity_planning = CapacityPlanning.find(params[:id])
    @capacity_planning.destroy

    respond_to do |format|
      format.html { redirect_to capacity_plannings_url }
      format.json { head :no_content }
    end
  end
  private

    def set_capacity_planning
      @capacity_planning = CapacityPlanning.find(params[:id])
    end

    def capacity_planning_params
      params.require(:capacity_planning).permit(:capacity_plan_active, :capacity_plan_created_id, :capacity_plan_description,
      :capacity_plan_name, :capacity_plan_notes, :capacity_plan_updated_id, attachment_attributes: [:attachable_id, :attachable_type, :attachment_revision_title, :attachment_revision_date,
                                         :attachment_effective_date, :attachment_name, :attachment_description, :attachment_document_type,
                                         :attachment_document_type_id, :attachment_notes, :attachment_public, :attachment_active,
                                         :attachment_status, :attachment_status_id, :attachment_created_id, :attachment_updated_id, :attachment,
                                         :attachment_file_name])
    end
end
