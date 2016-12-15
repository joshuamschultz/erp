class CompanyInfosController < ApplicationController
  before_action :set_page_info

  before_action :view_permissions, except: [:index,:show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_quality?  || current_user.is_logistics? || current_user.is_clerical? )
        authorize! :edit, CompanyInfo
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, CompanyInfo
    end
  end

  def set_page_info
      @menus[:system][:active] = "active"
  end

  # GET /company_infos
  # GET /company_infos.json
  def index
    if CompanyInfo.first
      redirect_to CompanyInfo.first
    else
      redirect_to new_company_info_path
    end
    # @company_infos = CompanyInfo.all

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @company_infos }
    # end
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
    @company_info = CompanyInfo.new(company_info_params)

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
      if @company_info.update_attributes(company_info_params)
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
  private
    def set_company_info
      @company_info = CompanyInfo.find(params[:id])
    end

    def company_info_params
      params.require(:company_info).permit(:company_active, :company_address1, :company_address2, :company_created_id,
      :company_fax, :company_mobile, :company_name, :company_phone1, :company_phone2, :company_slogan,
      :company_updated_id, :company_website, :image_attributes, :logo_attributes)
    end
end
