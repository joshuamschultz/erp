class ItemPartDimensionsController < ApplicationController
  before_action :set_page_info

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  # GET /item_part_dimensions
  # GET /item_part_dimensions.json
  def index
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimensions = @item_revision.item_part_dimensions.order("item_part_letter asc")
    if params[:critical].present?
        @item_part_dimensions = @item_part_dimensions.where(:item_part_critical => true)
    end

    respond_to do |format|
      format.html # index.html.erb
      @item_part_dimnsions = Array.new
      format.json {
          @item_part_dimensions = @item_part_dimensions.select{|item_part_dimension|
            item_part_dimnsion = Hash.new
            item_part_dimension.attributes.each do |key, value|
              item_part_dimnsion[key] = value
            end
            item_part_dimnsion[:dimension_type] = CommonActions.linkable(dimension_path(item_part_dimension.dimension), item_part_dimension.dimension.dimension_identifier)
            item_part_dimnsion[:gauge_name] = item_part_dimension.gauge.present? ? CommonActions.linkable(gauge_path(item_part_dimension.gauge), item_part_dimension.gauge.gauge_tool_name) : ""
            item_part_dimnsion[:item_part_letter] = "<a href='#{item_item_revision_item_part_dimension_path(@item, @item_revision ,item_part_dimension)}'> #{item_part_dimension.item_part_letter} </a>"
            if can? :edit, Item
              item_part_dimnsion[:links] = CommonActions.object_crud_paths( nil, edit_item_item_revision_item_part_dimension_path(@item, @item_revision ,item_part_dimension), nil)
            else
              item_part_dimnsion[:links]   = ""
            end
            @item_part_dimnsions.push(item_part_dimnsion)
          }
          render json: {:aaData => @item_part_dimnsions }
      }
    end
  end

  # GET /item_part_dimensions/1
  # GET /item_part_dimensions/1.json
  def show
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimension = @item_revision.item_part_dimensions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_part_dimension }
    end
  end

  # GET /item_part_dimensions/new
  # GET /item_part_dimensions/new.json
  def new
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimension = @item_revision.item_part_dimensions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_part_dimension }
    end
  end

  # GET /item_part_dimensions/1/edit
  def edit
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimension = @item_revision.item_part_dimensions.find(params[:id])
  end

  # POST /item_part_dimensions
  # POST /item_part_dimensions.json
  # item_item_part_dimensions_path(@item)
  def create
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimension = @item_revision.item_part_dimensions.new(item_part_dimension_params)
    respond_to do |format|
      if @item_part_dimension.save
        ItemPartDimension.process_dimension(@item_part_dimension, @item_revision)
        format.html { redirect_to @item, notice: 'Item dimension was successfully created.' }
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
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimension = @item_revision.item_part_dimensions.find(params[:id])

    respond_to do |format|
      if @item_part_dimension.update_attributes(item_part_dimension_params)
        format.html { redirect_to @item, notice: 'Item dimension was successfully created.' }
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
    @item_revision = @item.item_revisions.find(params[:item_revision_id])
    @item_part_dimension = @item_revision.item_part_dimensions.find(params[:id])
    @item_part_dimension.destroy

    respond_to do |format|
      format.html { redirect_to @item, notice: 'Item dimension was deleted successfully.' }
      format.json { head :no_content }
    end
  end
  private

    def set_item
      @item = Item.find(params[:item_id])
    end

    def item_part_dimension_params
      params.require(:item_part_dimension).permit(:item_part_active, :item_part_created_id, :item_part_critical,
                                    :item_part_letter, :item_part_neg_tolerance, :item_part_notes, :item_part_pos_tolerance,
                                    :item_part_dimension, :item_part_updated_id, :go_non_go, :dimension_string, :item_revision_id, :dimension_id, :gauge_id)

    end
end