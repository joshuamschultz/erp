class InventoryAdjustmentsController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]

  def set_page_info
      @menus[:inventory][:active] = "active"
      simple_form_validation = true
  end
  def set_autocomplete_values
    params[:inventory_adjustment][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:inventory_adjustment][:item_alt_name_id]
    params[:inventory_adjustment][:item_alt_name_id] = params[:org_alt_name_id] if params[:inventory_adjustment][:item_alt_name_id] == "" || params[:inventory_adjustment][:item_alt_name_id].nil?
  end
  # GET /inventory_adjustments
  # GET /inventory_adjustments.json
  def index
    @inventory_adjustments = InventoryAdjustment.all

    respond_to do |format|
      format.html 
      format.json { 
          @inventory_adjustments = @inventory_adjustments.select{|inventory_adjustment|
              inventory_adjustment[:id] = inventory_adjustment.id
              inventory_adjustment[:item_part_no] = CommonActions.linkable(item_path(inventory_adjustment.item), inventory_adjustment.item_alt_name.item_alt_identifier)
              inventory_adjustment[:inventory_adjustment_quantity] = inventory_adjustment.inventory_adjustment_quantity
              inventory_adjustment[:control_no] = CommonActions.linkable(quality_lot_path(inventory_adjustment.quality_lot),inventory_adjustment.quality_lot.lot_control_no)
              inventory_adjustment[:inventory_adjustment_description] = inventory_adjustment.inventory_adjustment_description

          }
          render json: {:aaData => @inventory_adjustments}
       }
    end
  end

  # GET /inventory_adjustments/1
  # GET /inventory_adjustments/1.json
  def show
    @inventory_adjustment = InventoryAdjustment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_adjustment }
    end
  end

  # GET /inventory_adjustments/new
  # GET /inventory_adjustments/new.json
  def new
    @inventory_adjustment = InventoryAdjustment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_adjustment }
    end
  end

  # GET /inventory_adjustments/1/edit
  def edit
    @inventory_adjustment = InventoryAdjustment.find(params[:id])
  end

  # POST /inventory_adjustments
  # POST /inventory_adjustments.json
  def create
    @inventory_adjustment = InventoryAdjustment.new(params[:inventory_adjustment])

    respond_to do |format|
      if @inventory_adjustment.save
        format.html { redirect_to @inventory_adjustment, notice: 'Inventory adjustment was successfully created.' }
        format.json { render json: @inventory_adjustment, status: :created, location: @inventory_adjustment }
      else
        format.html { render action: "new" }
        format.json { render json: @inventory_adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inventory_adjustments/1
  # PUT /inventory_adjustments/1.json
  def update
    @inventory_adjustment = InventoryAdjustment.find(params[:id])

    respond_to do |format|
      if @inventory_adjustment.update_attributes(params[:inventory_adjustment])
        format.html { redirect_to @inventory_adjustment, notice: 'Inventory adjustment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory_adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_adjustments/1
  # DELETE /inventory_adjustments/1.json
  def destroy
    @inventory_adjustment = InventoryAdjustment.find(params[:id])
    @inventory_adjustment.destroy

    respond_to do |format|
      format.html { redirect_to inventory_adjustments_url }
      format.json { head :no_content }
    end
  end
end
