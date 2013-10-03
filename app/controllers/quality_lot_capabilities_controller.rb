class QualityLotCapabilitiesController < ApplicationController
  before_filter :set_page_info
  
  def set_page_info
      @menus[:quality][:active] = "active"
  end

  # GET /quality_lot_capabilities
  # GET /quality_lot_capabilities.json
  def index
    @quality_lot = QualityLot.find(params[:quality_lot_id]) if params[:quality_lot_id]
    @quality_lot = QualityLot.first unless @quality_lot
    if @quality_lot
        @item_revision = @quality_lot.item_revision
        @item = @item_revision.item
        @quality_lot_capabilities = @quality_lot.quality_lot_capabilities.order(:item_part_dimension_id).group(:quality_lot_id, :item_part_dimension_id)
    else
        @quality_lot_capabilities = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @quality_lot_capabilities.each do |lot_capability|
              lot_capability[:lot_control_no] = CommonActions.linkable(quality_lot_path(lot_capability.quality_lot), lot_capability.quality_lot.lot_control_no)
              lot_capability[:item_part_letter] = CommonActions.linkable(item_item_revision_item_part_dimension_path(lot_capability.item_part_dimension.item_revision.item, lot_capability.item_part_dimension.item_revision, lot_capability.item_part_dimension), lot_capability.item_part_dimension.item_part_letter)
              lot_capability[:item_part_dimensions] = lot_capability.item_part_dimension.item_part_dimension.round(4) #CommonActions.linkable(item_item_revision_item_part_dimension_path(lot_capability.item_part_dimension.item_revision.item, lot_capability.item_part_dimension.item_revision, lot_capability.item_part_dimension), lot_capability.item_part_dimension.item_part_letter)
              lot_capability[:item_part_pos_tolerance] = (lot_capability.item_part_dimension.item_part_dimension + lot_capability.item_part_dimension.item_part_pos_tolerance).to_f.round(4)
              lot_capability[:item_part_neg_tolerance] = (lot_capability.item_part_dimension.item_part_dimension - lot_capability.item_part_dimension.item_part_neg_tolerance).to_f.round(4)

              lot_capability[:lot_dimension_avg] = (lot_capability.all_lot_capabilities.sum(:lot_dimension_value)/lot_capability.all_lot_capabilities.count).to_f.round(4)
              
              lot_capability_values = []
              lot_capability.all_lot_capabilities.collect(&:lot_dimension_value).each do |value|
                  lot_capability_values << value.to_f
              end

              lot_capability[:lot_dimension_std] = lot_capability_values.stdev.round(4) rescue 0
              lot_capability[:lot_dimension_max] = lot_capability.all_lot_capabilities.maximum(:lot_dimension_value).to_f.round(4)
              lot_capability[:lot_dimension_min] = lot_capability.all_lot_capabilities.minimum(:lot_dimension_value).to_f.round(4)
          end
          render json: { :aaData => @quality_lot_capabilities } 
      }
    end
  end

  # GET /quality_lot_capabilities/1
  # GET /quality_lot_capabilities/1.json
  def show
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_capability = QualityLotCapability.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_lot_capability }
    end
  end

  # GET /quality_lot_capabilities/new
  # GET /quality_lot_capabilities/new.json
  def new
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_capability = QualityLotCapability.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_lot_capability }
    end
  end

  # GET /quality_lot_capabilities/1/edit
  def edit
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_capability = QualityLotCapability.find(params[:id])
  end

  # POST /quality_lot_capabilities
  # POST /quality_lot_capabilities.json
  def create
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot.process_quality_lot_capabilities(params)
    redirect_to quality_lot_capabilities_path(quality_lot_id: @quality_lot.id), notice: 'Process capability was successfully updated.'

    # @quality_lot_capability = QualityLotCapability.new(params[:quality_lot_capability])
    # respond_to do |format|
    #   if @quality_lot_capability.save
    #     format.html { redirect_to @quality_lot_capability, notice: 'Quality lot capability was successfully created.' }
    #     format.json { render json: @quality_lot_capability, status: :created, location: @quality_lot_capability }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @quality_lot_capability.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /quality_lot_capabilities/1
  # PUT /quality_lot_capabilities/1.json
  def update
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_capability = QualityLotCapability.find(params[:id])

    respond_to do |format|
      if params[:status]
        @quality_lot_capability.update_attributes(:lot_dimension_status => params[:status])
        format.html { redirect_to quality_lot_capabilitys_url, notice: 'Status successfully updated.' }
      elsif @quality_lot_capability.update_attributes(params[:quality_lot_capability])
        format.html { redirect_to quality_lot_capability_path(@quality_lot_capability), notice: 'Process capability was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_lot_capability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_lot_capabilities/1
  # DELETE /quality_lot_capabilities/1.json
  def destroy
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_capability = QualityLotCapability.find(params[:id])
    @quality_lot_capability.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_capabilities_url }
      format.json { head :no_content }
    end
  end
end
