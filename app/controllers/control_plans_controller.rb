class ControlPlansController < ApplicationController
  # GET /control_plans
  # GET /control_plans.json
  def index
    @control_plans = ControlPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @control_plans }
    end
  end

  # GET /control_plans/1
  # GET /control_plans/1.json
  def show
    @control_plan = ControlPlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @control_plan }
    end
  end

  # GET /control_plans/new
  # GET /control_plans/new.json
  def new
    @control_plan = ControlPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @control_plan }
    end
  end

  # GET /control_plans/1/edit
  def edit
    @control_plan = ControlPlan.find(params[:id])
  end

  # POST /control_plans
  # POST /control_plans.json
  def create
    @control_plan = ControlPlan.new(params[:control_plan])

    respond_to do |format|
      if @control_plan.save
        format.html { redirect_to @control_plan, notice: 'Control plan was successfully created.' }
        format.json { render json: @control_plan, status: :created, location: @control_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @control_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /control_plans/1
  # PUT /control_plans/1.json
  def update
    @control_plan = ControlPlan.find(params[:id])

    respond_to do |format|
      if @control_plan.update_attributes(params[:control_plan])
        format.html { redirect_to @control_plan, notice: 'Control plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @control_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /control_plans/1
  # DELETE /control_plans/1.json
  def destroy
    @control_plan = ControlPlan.find(params[:id])
    @control_plan.destroy

    respond_to do |format|
      format.html { redirect_to control_plans_url }
      format.json { head :no_content }
    end
  end
end
