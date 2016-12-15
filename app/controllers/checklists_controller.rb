class ChecklistsController < ApplicationController
  before_action :set_page_info
  before_action :user_permissions

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical?   || current_user.is_vendor? || current_user.is_customer?  )
        authorize! :edit, Checklist
    end
  end

  def set_page_info
      @menus[:quality][:active] = "active"
  end
  # GET /checklists
  # GET /checklists.json
  def index
    @checklists = Checklist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @checklists = @checklists.select{|checklist|
          checklist[:id_name] = CommonActions.linkable(checklist_path(checklist), checklist.id)
          checklist[:lot_control_no] = CommonActions.linkable(quality_lot_path(checklist.quality_lot), checklist.quality_lot.lot_control_no)
          checklist[:quality_level] =  checklist.customer_quality.present? ? CommonActions.linkable(customer_quality_path(checklist.customer_quality), checklist.customer_quality.quality_name)  : ""
          checklist[:links] = ""
        }
        render json: {:aaData => @checklists}
      }
    end
  end

  # GET /checklists/1
  # GET /checklists/1.json
  def show
    @checklist = Checklist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @checklist }
    end
  end

  # GET /checklists/new
  # GET /checklists/new.json
  def new
    @checklist = Checklist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @checklist }
    end
  end

  # GET /checklists/1/edit
  def edit
    @checklist = Checklist.find(params[:id])
  end

  # POST /checklists
  # POST /checklists.json
  def create
    @checklist = Checklist.new(checklist_params)

    respond_to do |format|
      if @checklist.save
        format.html { redirect_to @checklist, notice: 'Checklist was successfully created.' }
        format.json { render json: @checklist, status: :created, location: @checklist }
      else
        format.html { render action: "new" }
        format.json { render json: @checklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /checklists/1
  # PUT /checklists/1.json
  def update
    @checklist = Checklist.find(params[:id])

    respond_to do |format|
      if @checklist.update_attributes(checklist_params)
        format.html { redirect_to @checklist, notice: 'Checklist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @checklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.json
  def destroy
    @checklist = Checklist.find(params[:id])
    @checklist.destroy

    respond_to do |format|
      format.html { redirect_to checklists_url }
      format.json { head :no_content }
    end
  end
  private

    def set_checklist
      @checklist = Checklist.find(params[:id])
    end

    def checklist_params
      params.require(:checklist).permit(:checklist_status, :quality_lot_id, :po_line_id, :customer_quality_id)
    end
end
