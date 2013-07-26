class OrganizationProcessesController < ApplicationController
  # GET /organization_processes
  # GET /organization_processes.json
  def index
    @organization_processes = OrganizationProcess.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organization_processes }
    end
  end

  # GET /organization_processes/1
  # GET /organization_processes/1.json
  def show
    @organization_process = OrganizationProcess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization_process }
    end
  end

  # GET /organization_processes/new
  # GET /organization_processes/new.json
  def new
    @organization_process = OrganizationProcess.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization_process }
    end
  end

  # GET /organization_processes/1/edit
  def edit
    @organization_process = OrganizationProcess.find(params[:id])
  end

  # POST /organization_processes
  # POST /organization_processes.json
  def create
    @organization_process = OrganizationProcess.new(params[:organization_process])

    respond_to do |format|
      if @organization_process.save
        format.html { redirect_to @organization_process, notice: 'Organization process was successfully created.' }
        format.json { render json: @organization_process, status: :created, location: @organization_process }
      else
        format.html { render action: "new" }
        format.json { render json: @organization_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organization_processes/1
  # PUT /organization_processes/1.json
  def update
    @organization_process = OrganizationProcess.find(params[:id])

    respond_to do |format|
      if @organization_process.update_attributes(params[:organization_process])
        format.html { redirect_to @organization_process, notice: 'Organization process was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_processes/1
  # DELETE /organization_processes/1.json
  def destroy
    @organization_process = OrganizationProcess.find(params[:id])
    @organization_process.destroy

    respond_to do |format|
      format.html { redirect_to organization_processes_url }
      format.json { head :no_content }
    end
  end
end
