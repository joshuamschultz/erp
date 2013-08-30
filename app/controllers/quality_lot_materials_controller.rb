class QualityLotMaterialsController < ApplicationController
  # GET /quality_lot_materials
  # GET /quality_lot_materials.json
  def index
    @quality_lot_materials = QualityLotMaterial.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quality_lot_materials }
    end
  end

  # GET /quality_lot_materials/1
  # GET /quality_lot_materials/1.json
  def show
    @quality_lot_material = QualityLotMaterial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_lot_material }
    end
  end

  # GET /quality_lot_materials/new
  # GET /quality_lot_materials/new.json
  def new
    @quality_lot_material = QualityLotMaterial.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_lot_material }
    end
  end

  # GET /quality_lot_materials/1/edit
  def edit
    @quality_lot_material = QualityLotMaterial.find(params[:id])
  end

  # POST /quality_lot_materials
  # POST /quality_lot_materials.json
  def create
    @quality_lot_material = QualityLotMaterial.new(params[:quality_lot_material])

    respond_to do |format|
      if @quality_lot_material.save
        format.html { redirect_to @quality_lot_material, notice: 'Quality lot material was successfully created.' }
        format.json { render json: @quality_lot_material, status: :created, location: @quality_lot_material }
      else
        format.html { render action: "new" }
        format.json { render json: @quality_lot_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_lot_materials/1
  # PUT /quality_lot_materials/1.json
  def update
    @quality_lot_material = QualityLotMaterial.find(params[:id])

    respond_to do |format|
      if @quality_lot_material.update_attributes(params[:quality_lot_material])
        format.html { redirect_to @quality_lot_material, notice: 'Quality lot material was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_lot_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_lot_materials/1
  # DELETE /quality_lot_materials/1.json
  def destroy
    @quality_lot_material = QualityLotMaterial.find(params[:id])
    @quality_lot_material.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_materials_url }
      format.json { head :no_content }
    end
  end
end
