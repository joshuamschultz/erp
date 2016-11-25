class PackagesController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]
  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && (current_user.is_logistics? || current_user.is_customer?)
        authorize! :edit, Package
    end 
  end

  def user_permissions
   if  user_signed_in? && (current_user.is_clerical? || current_user.is_vendor?) 
        authorize! :edit, Package
    end 
  end

  def set_autocomplete_values
    params[:package][:quality_lot_id], params[:quality_lot_id] = params[:quality_lot_id], params[:package][:quality_lot_id]
    params[:package][:quality_lot_id] = params[:org_quality_lot_id] if params[:package][:quality_lot_id] == ""
  end

  def set_page_info
      @menus[:quality][:active] = "active"
      simple_form_validation = false
  end

  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
         @packages = @packages.select{|package|
            if can? :edit , package
              package[:links] = CommonActions.object_crud_paths(nil, edit_package_path(package), nil)
            else
              package[:links] = ""
            end
            package[:id_link] = CommonActions.linkable(package_path(package), package.id)
           
            if can? :view , Package
              package[:lot_control_no] = CommonActions.linkable(quality_lot_path(package.quality_lot), package.quality_lot.lot_control_no)
            end

        }
        render json: {:aaData => @packages}
      }
    end
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
    @package = Package.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @package }
    end
  end

  # GET /packages/new
  # GET /packages/new.json
  def new
    @package = Package.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @package }
    end
  end

  # GET /packages/1/edit
  def edit
    @package = Package.find(params[:id])
  end

  # POST /packages
  # POST /packages.json
  def create
    @package = Package.new(params[:package])

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, notice: 'Package was successfully created.' }
        format.json { render json: @package, status: :created, location: @package }
      else
        format.html { render action: "new" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /packages/1
  # PUT /packages/1.json
  def update
    @package = Package.find(params[:id])

    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html { redirect_to @package, notice: 'Package was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      format.html { redirect_to packages_url }
      format.json { head :no_content }
    end
  end
   private

    def set_package
      @package = Package.find(params[:id])
    end

    def package_params
      params.require(:package).permit(:container_content_type, :container_file_name, :container_file_size, :container_gross_inc_weight,
                                      :container_height, :container_length, :container_per_layer_pallet, :container_per_pallet, :container_tare_weight, 
                                      :container_updated_at, :container_width, :dunnage_content_type, :dunnage_file_name, :dunnage_file_size, 
                                      :dunnage_tare_Weight, :dunnage_updated_at, :layers_per_pallet, :load_shipped_height, :load_shipped_length, 
                                      :load_shipped_width, :package_comment, :pallet_height, :pallet_length, :pallet_tare_weight, :pallet_width, 
                                      :part_content_type, :part_file_name, :part_file_size, :part_size_height, :part_size_length, :part_size_width, 
                                      :part_updated_at, :part_weight, :quantity_per_container, :unit_load_content_type, :unit_load_file_name, 
                                      :unit_load_file_size, :unit_load_gross, :unit_load_updated_at, :quality_lot_id, :part, :container, :dunnage, :unit_load,
                                      :dunnage_manufacturer ,:container_color_manufacturer ,:container_type_manufacturer ,:cover_cap_manufacturer ,:pallet_manufacturer ,
                                      :strech_shrink_manufacturer ,:banding_manufacturer ,:other_manufacturer,:dunnage_material , :container_color_material ,:container_type_material ,
                                      :cover_cap_material ,:pallet_material ,:strech_shrink_material ,:banding_material ,:other_material, :dunnage_lead_time ,:container_color_lead_time ,
                                      :container_type_lead_time ,:cover_cap_lead_time ,:pallet_lead_time ,:strech_shrink_lead_time ,:banding_lead_time ,:other_lead_time, :dunnage_ret_exp ,
                                      :container_color_ret_exp ,:container_type_ret_exp ,:cover_cap_ret_exp ,:pallet_ret_exp ,:strech_shrink_ret_exp ,:banding_ret_exp ,:other_ret_exp,
                                      :dunnage_comment ,:container_color_comment ,:container_type_comment ,:cover_cap_comment ,:pallet_comment ,:strech_shrink_comment ,
                                      :banding_comment ,:other_comment, :in_to_mm1, :in_to_mm2, :lbs_to_kg1, :lbs_to_kg2, :supplier_code)
  end
end
