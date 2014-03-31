class ItemMaterialsController < ApplicationController
  # GET /item_materials
  # GET /item_materials.json
  def index
    @item_materials = ItemMaterial.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_materials }
    end
  end

  # GET /item_materials/1
  # GET /item_materials/1.json
  def show
    @item_material = ItemMaterial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_material }
    end
  end

  # GET /item_materials/new
  # GET /item_materials/new.json
  def new
    @item_material = ItemMaterial.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_material }
    end
  end

  # GET /item_materials/1/edit
  def edit
    @item_material = ItemMaterial.find(params[:id])
  end

  # POST /item_materials
  # POST /item_materials.json
  def create
    @item_material = ItemMaterial.new(params[:item_material])

    respond_to do |format|
      if @item_material.save
        format.html { redirect_to @item_material, notice: 'Item material was successfully created.' }
        format.json { render json: @item_material, status: :created, location: @item_material }
      else
        format.html { render action: "new" }
        format.json { render json: @item_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_materials/1
  # PUT /item_materials/1.json
  def update
    @item_material = ItemMaterial.find(params[:id])

    respond_to do |format|
      if @item_material.update_attributes(params[:item_material])
        format.html { redirect_to @item_material, notice: 'Item material was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_materials/1
  # DELETE /item_materials/1.json
  def destroy
    @item_material = ItemMaterial.find(params[:id])
    @item_material.destroy

    respond_to do |format|
      format.html { redirect_to item_materials_url }
      format.json { head :no_content }
    end
  end
end
