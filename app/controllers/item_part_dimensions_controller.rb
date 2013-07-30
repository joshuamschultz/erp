class ItemPartDimensionsController < ApplicationController
  # GET /item_part_dimensions
  # GET /item_part_dimensions.json
  def index
    @item_part_dimensions = ItemPartDimension.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_part_dimensions }
    end
  end

  # GET /item_part_dimensions/1
  # GET /item_part_dimensions/1.json
  def show
    @item_part_dimension = ItemPartDimension.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_part_dimension }
    end
  end

  # GET /item_part_dimensions/new
  # GET /item_part_dimensions/new.json
  def new
    @item_part_dimension = ItemPartDimension.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_part_dimension }
    end
  end

  # GET /item_part_dimensions/1/edit
  def edit
    @item_part_dimension = ItemPartDimension.find(params[:id])
  end

  # POST /item_part_dimensions
  # POST /item_part_dimensions.json
  def create
    @item_part_dimension = ItemPartDimension.new(params[:item_part_dimension])

    respond_to do |format|
      if @item_part_dimension.save
        format.html { redirect_to @item_part_dimension, notice: 'Item part dimension was successfully created.' }
        format.json { render json: @item_part_dimension, status: :created, location: @item_part_dimension }
      else
        format.html { render action: "new" }
        format.json { render json: @item_part_dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_part_dimensions/1
  # PUT /item_part_dimensions/1.json
  def update
    @item_part_dimension = ItemPartDimension.find(params[:id])

    respond_to do |format|
      if @item_part_dimension.update_attributes(params[:item_part_dimension])
        format.html { redirect_to @item_part_dimension, notice: 'Item part dimension was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_part_dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_part_dimensions/1
  # DELETE /item_part_dimensions/1.json
  def destroy
    @item_part_dimension = ItemPartDimension.find(params[:id])
    @item_part_dimension.destroy

    respond_to do |format|
      format.html { redirect_to item_part_dimensions_url }
      format.json { head :no_content }
    end
  end
end
