class QualityLotDimensionsController < ApplicationController
  before_filter :set_page_info
  
  def set_page_info
      @menus[:quality][:active] = "active"
  end

  # GET /quality_lot_dimensions
  # GET /quality_lot_dimensions.json
  def index
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @item_revision = @quality_lot.item_revision
    @item = @item_revision.item
    @quality_lot_dimensions = @quality_lot.quality_lot_dimensions.group(:quality_lot_id, :item_part_dimension_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @quality_lot_dimensions.each do |lot_dimension|
              lot_dimension[:lot_control_no] = CommonActions.linkable(quality_lot_path(lot_dimension.quality_lot), lot_dimension.quality_lot.lot_control_no)
              lot_dimension[:item_part_letter] = CommonActions.linkable(item_item_revision_item_part_dimension_path(lot_dimension.item_part_dimension.item_revision.item, lot_dimension.item_part_dimension.item_revision, lot_dimension.item_part_dimension), lot_dimension.item_part_dimension.item_part_letter)
              lot_dimension[:item_part_pos_tolerance] = lot_dimension.item_part_dimension.item_part_pos_tolerance
              lot_dimension[:item_part_neg_tolerance] = lot_dimension.item_part_dimension.item_part_neg_tolerance

              # lot_dimension_links = []
              # lot_dimension_links <<  {:name => "Accept", :method => "put", :path => quality_lot_dimension_path(lot_dimension, status: "accepted") } if lot_dimension.lot_dimension_status == "rejected" || lot_dimension.lot_dimension_status.nil?
              # lot_dimension_links <<  {:name => "Reject", :method => "put", :path => quality_lot_dimension_path(lot_dimension, status: "rejected") } if lot_dimension.lot_dimension_status == "accepted" || lot_dimension.lot_dimension_status.nil?
              # lot_dimension[:links] = CommonActions.object_crud_paths(nil, edit_quality_lot_dimension_path(lot_dimension, quality_lot_id: @quality_lot.id), nil)

              lot_dimension[:lot_dimension_avg] = "%0.6f" % (lot_dimension.all_lot_dimensions.sum(:lot_dimension_value)/lot_dimension.all_lot_dimensions.count)
              
              lot_dimension_values = []
              lot_dimension.all_lot_dimensions.collect(&:lot_dimension_value).each do |value|
                  lot_dimension_values << value.to_i
              end

              lot_dimension[:lot_dimension_std] = 0 # "%0.6f" % lot_dimension_values.stdev
              lot_dimension[:lot_dimension_max] = lot_dimension.all_lot_dimensions.maximum(:lot_dimension_value)
              lot_dimension[:lot_dimension_min] = lot_dimension.all_lot_dimensions.minimum(:lot_dimension_value)
          end
          render json: { :aaData => @quality_lot_dimensions } 
      }
    end
  end

  # GET /quality_lot_dimensions/1
  # GET /quality_lot_dimensions/1.json
  def show
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_dimension = QualityLotDimension.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_lot_dimension }
    end
  end

  # GET /quality_lot_dimensions/new
  # GET /quality_lot_dimensions/new.json
  def new
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_dimension = QualityLotDimension.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_lot_dimension }
    end
  end

  # GET /quality_lot_dimensions/1/edit
  def edit
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_dimension = QualityLotDimension.find(params[:id])
  end

  # POST /quality_lot_dimensions
  # POST /quality_lot_dimensions.json
  def create
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot.process_quality_lot_dimensions(params)
    redirect_to quality_lot_dimensions_path(quality_lot_id: @quality_lot.id), notice: 'Dimension analysis was successfully updated.'

    # respond_to do |format|
    #   if @quality_lot_dimension.save
    #     format.html { redirect_to quality_lot_dimension_path(@quality_lot_dimension), notice: 'Dimension analysis was successfully created.' }
    #     format.json { render json: @quality_lot_dimension, status: :created, location: @quality_lot_dimension }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @quality_lot_dimension.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /quality_lot_dimensions/1
  # PUT /quality_lot_dimensions/1.json
  def update
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_dimension = QualityLotDimension.find(params[:id])

    respond_to do |format|
      if params[:status]
        @quality_lot_dimension.update_attributes(:lot_dimension_status => params[:status])
        format.html { redirect_to quality_lot_dimensions_url, notice: 'Status successfully updated.' }
      elsif @quality_lot_dimension.update_attributes(params[:quality_lot_dimension])
        format.html { redirect_to quality_lot_dimension_path(@quality_lot_dimension), notice: 'Dimension analysis was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_lot_dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_lot_dimensions/1
  # DELETE /quality_lot_dimensions/1.json
  def destroy
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_dimension = QualityLotDimension.find(params[:id])
    @quality_lot_dimension.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_dimensions_url }
      format.json { head :no_content }
    end
  end
end
