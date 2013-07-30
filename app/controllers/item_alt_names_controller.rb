class ItemAltNamesController < ApplicationController
  # GET /item_alt_names
  # GET /item_alt_names.json
  def index
    @item_alt_names = ItemAltName.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_alt_names }
    end
  end

  # GET /item_alt_names/1
  # GET /item_alt_names/1.json
  def show
    @item_alt_name = ItemAltName.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_alt_name }
    end
  end

  # GET /item_alt_names/new
  # GET /item_alt_names/new.json
  def new
    @item_alt_name = ItemAltName.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_alt_name }
    end
  end

  # GET /item_alt_names/1/edit
  def edit
    @item_alt_name = ItemAltName.find(params[:id])
  end

  # POST /item_alt_names
  # POST /item_alt_names.json
  def create
    @item_alt_name = ItemAltName.new(params[:item_alt_name])

    respond_to do |format|
      if @item_alt_name.save
        format.html { redirect_to @item_alt_name, notice: 'Item alt name was successfully created.' }
        format.json { render json: @item_alt_name, status: :created, location: @item_alt_name }
      else
        format.html { render action: "new" }
        format.json { render json: @item_alt_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_alt_names/1
  # PUT /item_alt_names/1.json
  def update
    @item_alt_name = ItemAltName.find(params[:id])

    respond_to do |format|
      if @item_alt_name.update_attributes(params[:item_alt_name])
        format.html { redirect_to @item_alt_name, notice: 'Item alt name was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_alt_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_alt_names/1
  # DELETE /item_alt_names/1.json
  def destroy
    @item_alt_name = ItemAltName.find(params[:id])
    @item_alt_name.destroy

    respond_to do |format|
      format.html { redirect_to item_alt_names_url }
      format.json { head :no_content }
    end
  end
end
