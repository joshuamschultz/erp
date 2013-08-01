class ItemPartDimensionsController < ApplicationController
  # GET /item_part_dimensions
  # GET /item_part_dimensions.json
  def index
    @item = Item.find(params[:item_id])
    @item_part_dimensions = @item.item_part_dimensions.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @item_part_dimensions = @item_part_dimensions.select{|item_part_dimension|
            item_part_dimension[:dimension_type] = item_part_dimension.dimension.dimension_identifier
            item_part_dimension[:gauge] = item_part_dimension.dimension.gauge.gauge_tool_name
            # item_part_dimension[:item_part_letter] = "<a href='#{item_item_part_dimension_path(@item, item_part_dimension)}'> #{item_part_dimension.item_part_letter} </a>"
            item_part_dimension[:links] = CommonActions.object_crud_paths( nil, edit_item_item_part_dimension_path(@item, item_part_dimension), nil)      
          }
          render json: {:aaData => @item_part_dimensions } 
      }                
    end
  end

  # GET /item_part_dimensions/1
  # GET /item_part_dimensions/1.json
  def show
    @item = Item.find(params[:item_id])
    @item_part_dimension = @item.item_part_dimensions.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_part_dimension }
    end
  end

  # GET /item_part_dimensions/new
  # GET /item_part_dimensions/new.json
  def new
    @item = Item.find(params[:item_id])
    @item_part_dimension = @item.item_part_dimensions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_part_dimension }
    end
  end

  # GET /item_part_dimensions/1/edit
  def edit
    @item = Item.find(params[:item_id])
    @item_part_dimension = @item.item_part_dimensions.find(params[:id])
  end

  # POST /item_part_dimensions
  # POST /item_part_dimensions.json
  # item_item_part_dimensions_path(@item)
  def create
    @item = Item.find(params[:item_id])
    @item_part_dimension = @item.item_part_dimensions.new(params[:item_part_dimension])

    respond_to do |format|
      if @item_part_dimension.save
        format.html { redirect_to item_path(@item), notice: 'Item dimension was successfully created.' }
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
    @item = Item.find(params[:item_id])
    @item_part_dimension = @item.item_part_dimensions.find(params[:id])

    respond_to do |format|
      if @item_part_dimension.update_attributes(params[:item_part_dimension])
        format.html { redirect_to item_path(@item), notice: 'Item dimension was successfully created.' }
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
    @item = Item.find(params[:item_id])
    @item_part_dimension = @item.item_part_dimensions.find(params[:id])
    @item_part_dimension.destroy

    respond_to do |format|
      format.html { redirect_to item_path(@item), notice: 'Item dimension was deleted created.' }
      format.json { head :no_content }
    end
  end
end
