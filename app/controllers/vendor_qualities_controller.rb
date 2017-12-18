class VendorQualitiesController < ApplicationController
  before_action :set_vendor_quality, only: %i[show edit update destroy]
  before_action :set_page_info
  before_action :user_permissions

  def index
    @vendor_qualities = VendorQuality.all
  end

  def show
    @attachable = @vendor_quality
  end

  def new
    @duplicate = VendorQuality.find_by_id(params[:quality_id])
    @vendor_quality = @duplicate.present? ? @duplicate.dup : VendorQuality.new
  end

  def edit
  end

  def create
    @vendor_quality = VendorQuality.new(vendor_quality_params)
    if @vendor_quality.save
      respond_with @vendor_quality
    else
      render action: "new"
    end
  end

  def update
    if @vendor_quality.update_attributes(vendor_quality_params)
      respond_with @vendor_quality
    else
      render action: "edit"
    end
  end

  def destroy
    @vendor_quality.destroy
    redirect_to vendor_qualities_url
  end

  def set_default
    @vendor_quality = VendorQuality.find(params[:vendor_quality_id])
    if @vendor_quality
        MasterType.where(:type_category => "default_vendor_quality").destroy_all
        MasterType.create(:type_name => "Default Vendor Quality", :type_description => "", :type_value => @vendor_quality.id, :type_category => "default_vendor_quality", :type_active => true)
    end
    redirect_to @vendor_quality
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer? )
      authorize! :edit, VendorQuality
    end
  end

  def set_page_info
      @menus[:quality][:active] = "active"
  end

  private

    def set_vendor_quality
      @vendor_quality = VendorQuality.find(params[:id])
    end

    def vendor_quality_params
      params.require(:vendor_quality).permit(:quality_active, :quality_created_id, :quality_description,
                                             :quality_name, :quality_notes, :quality_updated_id)
    end
end
