class QualityLotDimensionsController < ApplicationController
  # GET /quality_lot_dimensions
  # GET /quality_lot_dimensions.json
  def index
    @quality_lot_dimensions = QualityLotDimension.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @quality_lot_dimensions = @quality_lot_dimensions.select{|lot_dimension|
          lot_dimension[:lot_control_no] = CommonActions.linkable(quality_lot_path(lot_dimension.quality_lot), lot_dimension.quality_lot.lot_control_no)
          lot_dimension[:item_part_letter] = CommonActions.linkable(item_item_revision_item_part_dimension_path(lot_dimension.item_part_dimension.item_revision.item, lot_dimension.item_part_dimension.item_revision, lot_dimension.item_part_dimension), lot_dimension.item_part_dimension.item_part_letter)
          lot_dimension[:item_part_pos_tolerance] = lot_dimension.item_part_dimension.item_part_pos_tolerance
          lot_dimension[:item_part_neg_tolerance] = lot_dimension.item_part_dimension.item_part_neg_tolerance
          lot_dimension[:links] = CommonActions.object_crud_paths(nil, edit_quality_lot_dimension_path(lot_dimension), nil)
        }
        render json: { :aaData => @quality_lot_dimensions } 
      }
    end
  end

  # GET /quality_lot_dimensions/1
  # GET /quality_lot_dimensions/1.json
  def show
    @quality_lot_dimension = QualityLotDimension.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_lot_dimension }
    end
  end

  # GET /quality_lot_dimensions/new
  # GET /quality_lot_dimensions/new.json
  def new
    @quality_lot_dimension = QualityLotDimension.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_lot_dimension }
    end
  end

  # GET /quality_lot_dimensions/1/edit
  def edit
    @quality_lot_dimension = QualityLotDimension.find(params[:id])
  end

  # POST /quality_lot_dimensions
  # POST /quality_lot_dimensions.json
  def create
    @quality_lot_dimension = QualityLotDimension.new(params[:quality_lot_dimension])

    respond_to do |format|
      if @quality_lot_dimension.save
        format.html { redirect_to quality_lot_dimensions_url, notice: 'Dimension analysis was successfully created.' }
        format.json { render json: @quality_lot_dimension, status: :created, location: @quality_lot_dimension }
      else
        format.html { render action: "new" }
        format.json { render json: @quality_lot_dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_lot_dimensions/1
  # PUT /quality_lot_dimensions/1.json
  def update
    @quality_lot_dimension = QualityLotDimension.find(params[:id])

    respond_to do |format|
      if @quality_lot_dimension.update_attributes(params[:quality_lot_dimension])
        format.html { redirect_to quality_lot_dimensions_url, notice: 'Dimension analysis was successfully updated.' }
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
    @quality_lot_dimension = QualityLotDimension.find(params[:id])
    @quality_lot_dimension.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_dimensions_url }
      format.json { head :no_content }
    end
  end
end
