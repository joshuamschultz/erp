class InventoryAdjustmentsController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  before_action :user_permissions


  def user_permissions
    if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, InventoryAdjustment
    end
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
      simple_form_validation = true
      p simple_form_validation
  end
  def set_autocomplete_values
    params[:inventory_adjustment][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:inventory_adjustment][:item_alt_name_id]
    params[:inventory_adjustment][:item_alt_name_id] = params[:org_alt_name_id] if params[:inventory_adjustment][:item_alt_name_id] == "" || params[:inventory_adjustment][:item_alt_name_id].nil?
  end
  # GET /inventory_adjustments
  # GET /inventory_adjustments.json
  def index
    if params[:item_id].present?
        @item = Item.find(params[:item_id])
        @inventory_adjustments = @item.inventory_adjustments.order('created_at desc')
    else
      @inventory_adjustments = InventoryAdjustment.all
    end

    respond_to do |format|
      format.html
      @inventory_adjustmnts = Array.new
      format.json {
          @inventory_adjustments = @inventory_adjustments.select{|inventory_adjustment|
              inventory_adjustmnt = Hash.new
              inventory_adjustment.attributes.each do |key, value|
                inventory_adjustmnt[key] = value
              end
              inventory_adjustmnt[:id] = inventory_adjustment.id
              inventory_adjustmnt[:item_part_no] = CommonActions.linkable(item_path(inventory_adjustment.item), inventory_adjustment.item_alt_name.item_alt_identifier, {revision_id: inventory_adjustment.item_alt_name.current_revision.id, item_alt_name_id: inventory_adjustment.item_alt_name.id})
              inventory_adjustmnt[:inventory_adjustment_quantity] = inventory_adjustment.inventory_adjustment_quantity
              inventory_adjustmnt[:control_no] = CommonActions.linkable(quality_lot_path(inventory_adjustment.quality_lot),inventory_adjustment.quality_lot.lot_control_no)
              inventory_adjustmnt[:inventory_adjustment_description] = inventory_adjustment.inventory_adjustment_description
              inventory_adjustmnt[:links] = CommonActions.object_crud_paths( nil, edit_inventory_adjustment_path(inventory_adjustment), nil)
              @inventory_adjustmnts.push(inventory_adjustmnt)
          }
          render json: {:aaData => @inventory_adjustmnts}
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
    @inventory_adjustment = InventoryAdjustment.new(inventory_adjustment_params)

    respond_to do |format|
      if @inventory_adjustment.save
        format.html { redirect_to inventory_adjustments_path, notice: 'Inventory adjustment was successfully created.' }
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
      if @inventory_adjustment.update_attributes(inventory_adjustment_params)
        format.html { redirect_to inventory_adjustments_path, notice: 'Inventory adjustment was successfully updated.' }
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
      format.html { redirect_to new_inventory_adjustment_path, :notice => ' inventory_adjustment was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  private

      def set_inventory_adjustment
        @inventory_adjustment = InventoryAdjustment.find(params[:id])
      end

      def inventory_adjustment_params
        params.require(:inventory_adjustment).permit(:inventory_adjustment_description, :inventory_adjustment_quantity, :item_alt_name_id, :item_id, :quality_lot_id)
      end
end
