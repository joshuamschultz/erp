class ItemSelectedNamesController < ApplicationController
  # GET /item_selected_names
  # GET /item_selected_names.json
  def index
    @item_selected_names = ItemSelectedName.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_selected_names }
    end
  end

  # GET /item_selected_names/1
  # GET /item_selected_names/1.json
  def show
    @item_selected_name = ItemSelectedName.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_selected_name }
    end
  end

  # GET /item_selected_names/new
  # GET /item_selected_names/new.json
  def new
    @item_selected_name = ItemSelectedName.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_selected_name }
    end
  end

  # GET /item_selected_names/1/edit
  def edit
    @item_selected_name = ItemSelectedName.find(params[:id])
  end

  # POST /item_selected_names
  # POST /item_selected_names.json
  def create
    @item_selected_name = ItemSelectedName.new(params[:item_selected_name])

    respond_to do |format|
      if @item_selected_name.save
        format.html { redirect_to @item_selected_name, notice: 'Item selected name was successfully created.' }
        format.json { render json: @item_selected_name, status: :created, location: @item_selected_name }
      else
        format.html { render action: "new" }
        format.json { render json: @item_selected_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_selected_names/1
  # PUT /item_selected_names/1.json
  def update
    @item_selected_name = ItemSelectedName.find(params[:id])

    respond_to do |format|
      if @item_selected_name.update_attributes(params[:item_selected_name])
        format.html { redirect_to @item_selected_name, notice: 'Item selected name was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_selected_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_selected_names/1
  # DELETE /item_selected_names/1.json
  def destroy
    @item_selected_name = ItemSelectedName.find(params[:id])
    @item_selected_name.destroy

    respond_to do |format|
      format.html { redirect_to item_selected_names_url }
      format.json { head :no_content }
    end
  end
end