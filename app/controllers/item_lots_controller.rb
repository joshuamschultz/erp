class ItemLotsController < ApplicationController
  # GET /item_lots
  # GET /item_lots.json
  def index
    @item_lots = ItemLot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_lots }
    end
  end

  # GET /item_lots/1
  # GET /item_lots/1.json
  def show
    @item_lot = ItemLot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_lot }
    end
  end

  # GET /item_lots/new
  # GET /item_lots/new.json
  def new
    @item_lot = ItemLot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_lot }
    end
  end

  # GET /item_lots/1/edit
  def edit
    @item_lot = ItemLot.find(params[:id])
  end

  # POST /item_lots
  # POST /item_lots.json
  def create
    @item_lot = ItemLot.new(params[:item_lot])

    respond_to do |format|
      if @item_lot.save
        format.html { redirect_to @item_lot, notice: 'Item lot was successfully created.' }
        format.json { render json: @item_lot, status: :created, location: @item_lot }
      else
        format.html { render action: "new" }
        format.json { render json: @item_lot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_lots/1
  # PUT /item_lots/1.json
  def update
    @item_lot = ItemLot.find(params[:id])

    respond_to do |format|
      if @item_lot.update_attributes(params[:item_lot])
        format.html { redirect_to @item_lot, notice: 'Item lot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_lot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_lots/1
  # DELETE /item_lots/1.json
  def destroy
    @item_lot = ItemLot.find(params[:id])
    @item_lot.destroy

    respond_to do |format|
      format.html { redirect_to item_lots_url }
      format.json { head :no_content }
    end
  end
end
