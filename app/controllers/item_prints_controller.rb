class ItemPrintsController < ApplicationController
  # GET /item_prints
  # GET /item_prints.json
  def index
    @item_prints = ItemPrint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_prints }
    end
  end

  # GET /item_prints/1
  # GET /item_prints/1.json
  def show
    @item_print = ItemPrint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_print }
    end
  end

  # GET /item_prints/new
  # GET /item_prints/new.json
  def new
    @item_print = ItemPrint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_print }
    end
  end

  # GET /item_prints/1/edit
  def edit
    @item_print = ItemPrint.find(params[:id])
  end

  # POST /item_prints
  # POST /item_prints.json
  def create
    @item_print = ItemPrint.new(params[:item_print])

    respond_to do |format|
      if @item_print.save
        format.html { redirect_to @item_print, notice: 'Item print was successfully created.' }
        format.json { render json: @item_print, status: :created, location: @item_print }
      else
        format.html { render action: "new" }
        format.json { render json: @item_print.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_prints/1
  # PUT /item_prints/1.json
  def update
    @item_print = ItemPrint.find(params[:id])

    respond_to do |format|
      if @item_print.update_attributes(params[:item_print])
        format.html { redirect_to @item_print, notice: 'Item print was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_print.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_prints/1
  # DELETE /item_prints/1.json
  def destroy
    @item_print = ItemPrint.find(params[:id])
    @item_print.destroy

    respond_to do |format|
      format.html { redirect_to item_prints_url }
      format.json { head :no_content }
    end
  end
end
