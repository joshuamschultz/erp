class CompanyInfosController < ApplicationController
  before_action :set_company_info, except: %i[index new]
  before_action :set_page_info
  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions

  def index
    if CompanyInfo.first
      redirect_to CompanyInfo.first
    else
      redirect_to new_company_info_path
    end
  end

  def show; end

  def new
    @company_info = CompanyInfo.new
    respond_with(@company_info)
  end

  def edit; end

  def create
    @company_info = CompanyInfo.new(company_info_params)

    respond_to do |format|
      if @company_info.save
        format.html { redirect_to @company_info, notice: 'Corporate Identity was successfully created.' }
        format.json { render json: @company_info, status: :created, location: @company_info }
      else
        format.html { render action: 'new' }
        format.json { render json: @company_info.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @company_info.update_attributes(company_info_params)
        format.html { redirect_to @company_info, notice: 'Corporate Information was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company_info.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company_info.destroy

    respond_to do |format|
      format.html { redirect_to company_infos_url }
      format.json { head :no_content }
    end
  end

  def view_permissions
    if user_signed_in? && (current_user.is_quality? || current_user.is_logistics? || current_user.is_clerical?)
      authorize! :edit, CompanyInfo
    end
  end

  def user_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, CompanyInfo
    end
  end

  def set_page_info
    @menus[:system][:active] = 'active'
  end

  private

  def set_company_info
    @company_info = CompanyInfo.find(params[:id])
  end

  def company_info_params
    params.require(:company_info).permit(:company_active, :company_address1, :company_address2, :company_created_id,
                                         :company_fax, :company_mobile, :company_name, :company_phone1, :company_phone2, :company_slogan,
                                         :company_updated_id, :company_website,
                                         image_attributes: %i[image_active image_content_type image_created_id image_description
                                                              image_file_name image_file_size image_notes image_public image_title image_updated_id
                                                              imageable_id imageable_type image],
                                         logo_attributes: %i[joint_active joint_content_type joint_created_id joint_description
                                                             joint_file_name joint_file_size joint_notes joint_public joint_title joint_updated_id
                                                             jointable_id jointable_type joint])
  end
end
