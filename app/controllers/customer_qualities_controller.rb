class CustomerQualitiesController < ApplicationController
  before_action :set_page_info
  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && current_user.is_logistics?
      authorize! :edit, CustomerQuality
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer? )
      authorize! :edit, CustomerQuality
    end
  end

  def set_page_info
      @menus[:quality][:active] = "active"
  end

  # GET /customer_qualities
  # GET /customer_qualities.json
  def index
      @customer_qualities = CustomerQuality.all

      respond_to do |format|
          format.html # index.html.erb
          @customer_qualitis = Array.new
          format.json {

            @customer_qualities = @customer_qualities.select{|quality|
              qualiti = Hash.new
              quality.attributes.each do |key, value|
                qualiti[key] = value
              end
              qualiti[:documents] = quality.master_types.collect(&:type_name)
              # quality[:links] = CommonActions.object_crud_paths(customer_quality_path(quality), edit_customer_quality_path(quality),
              # customer_quality_path(quality))

            if (can? :edit, quality)
             qualiti[:links] = CommonActions.object_crud_paths(customer_quality_path(quality), false,
              customer_quality_path(quality))
            else
              qualiti[:links] = CommonActions.object_crud_paths(customer_quality_path(quality), false,nil)
            end

            @customer_qualitis.push(qualiti)
            }

            render json: {:aaData => @customer_qualitis}
          }
      end
  end

  # GET /customer_qualities/1
  # GET /customer_qualities/1.json
  def show
    @customer_quality = CustomerQuality.find(params[:id])
    @attachable = @customer_quality

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_quality }
    end
  end

  # GET /customer_qualities/new
  # GET /customer_qualities/new.json
  def new
    @duplicate = CustomerQuality.find_by_id(params[:quality_id])
    @customer_quality = @duplicate.present? ? @duplicate.dup : CustomerQuality.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_quality }
    end
  end

  # GET /customer_qualities/1/edit
  def edit
    @customer_quality = CustomerQuality.find(params[:id])
  end

  # POST /customer_qualities
  # POST /customer_qualities.json
  def create
    @customer_quality = CustomerQuality.new(customer_quality_params)
    respond_to do |format|
      if @customer_quality.save
        CustomerQuality.quality_level_associations(@customer_quality, params)
        format.html { redirect_to customer_qualities_url, notice: 'Quality level was successfully created.' }
        format.json { render json: @customer_quality, status: :created, location: @customer_quality }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customer_qualities/1
  # PUT /customer_qualities/1.json
  def update
    @customer_quality = CustomerQuality.find(params[:id])

    respond_to do |format|
      if @customer_quality.update_attributes(customer_quality_params)
        CustomerQuality.quality_level_associations(@customer_quality, params)
        format.html { redirect_to customer_qualities_url, notice: 'Quality Level was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_qualities/1
  # DELETE /customer_qualities/1.json
  def destroy
    @customer_quality = CustomerQuality.find(params[:id])
    @customer_quality.destroy

    respond_to do |format|
      format.html { redirect_to customer_qualities_url }
      format.json { head :no_content }
    end
  end

  def set_default
    @customer_quality = CustomerQuality.find(params[:customer_quality_id])
    respond_to do |format|
      if @customer_quality
          MasterType.where(:type_category => "default_customer_quality").destroy_all
          MasterType.create(:type_name => "Default Customer Quality", :type_description => "", :type_value => @customer_quality.id, :type_category => "default_customer_quality", :type_active => true)
      end
      format.html { redirect_to @customer_quality, notice: 'Quality Level was successfully added as default.' }
      format.json { head :no_content }
    end
  end
  private

    def set_customer_quality
      @customer_quality = CustomerQuality.find(params[:id])
    end

    def customer_quality_params
      params.require(:customer_quality).permit( :quality_active, :quality_control_plan, :quality_created_id, :quality_description,
                                                 :quality_dimensional_cofc, :quality_floor_plan, :quality_fmea, :quality_form, :quality_gauge,
                                                 :quality_material_cofc, :quality_name, :quality_notes, :quality_packaging, :quality_process_flow,
                                                 :quality_psw, :quality_study, :quality_supplier_a, :quality_supplier_b, :quality_updated_id)
    end

end
