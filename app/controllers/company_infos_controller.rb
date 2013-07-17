class CompanyInfosController < ApplicationController
  # GET /company_infos
  # GET /company_infos.json
  def index
    @company_infos = CompanyInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @company_infos }
    end
  end

  # GET /company_infos/1
  # GET /company_infos/1.json
  def show
    @company_info = CompanyInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company_info }
    end
  end

  # GET /company_infos/new
  # GET /company_infos/new.json
  def new
    @company_info = CompanyInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company_info }
    end
  end

  # GET /company_infos/1/edit
  def edit
    @company_info = CompanyInfo.find(params[:id])
  end

  # POST /company_infos
  # POST /company_infos.json
  def create
    @company_info = CompanyInfo.new(params[:company_info])

    respond_to do |format|
      if @company_info.save
        format.html { redirect_to @company_info, notice: 'Company info was successfully created.' }
        format.json { render json: @company_info, status: :created, location: @company_info }
      else
        format.html { render action: "new" }
        format.json { render json: @company_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /company_infos/1
  # PUT /company_infos/1.json
  def update
    @company_info = CompanyInfo.find(params[:id])

    respond_to do |format|
      if @company_info.update_attributes(params[:company_info])
        format.html { redirect_to @company_info, notice: 'Company info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_infos/1
  # DELETE /company_infos/1.json
  def destroy
    @company_info = CompanyInfo.find(params[:id])
    @company_info.destroy

    respond_to do |format|
      format.html { redirect_to company_infos_url }
      format.json { head :no_content }
    end
  end
end
