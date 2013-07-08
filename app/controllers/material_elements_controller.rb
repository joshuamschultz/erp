class MaterialElementsController < ApplicationController
  # GET /material_elements
  # GET /material_elements.json
  def index
    @material_elements = MaterialElement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @material_elements }
    end
  end

  # GET /material_elements/1
  # GET /material_elements/1.json
  def show
    @material_element = MaterialElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @material_element }
    end
  end

  # GET /material_elements/new
  # GET /material_elements/new.json
  def new
    @material_element = MaterialElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material_element }
    end
  end

  # GET /material_elements/1/edit
  def edit
    @material_element = MaterialElement.find(params[:id])
  end

  # POST /material_elements
  # POST /material_elements.json
  def create
    @material_element = MaterialElement.new(params[:material_element])

    respond_to do |format|
      if @material_element.save
        format.html { redirect_to @material_element, notice: 'Material element was successfully created.' }
        format.json { render json: @material_element, status: :created, location: @material_element }
      else
        format.html { render action: "new" }
        format.json { render json: @material_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /material_elements/1
  # PUT /material_elements/1.json
  def update
    @material_element = MaterialElement.find(params[:id])

    respond_to do |format|
      if @material_element.update_attributes(params[:material_element])
        format.html { redirect_to @material_element, notice: 'Material element was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @material_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /material_elements/1
  # DELETE /material_elements/1.json
  def destroy
    @material_element = MaterialElement.find(params[:id])
    @material_element.destroy

    respond_to do |format|
      format.html { redirect_to material_elements_url }
      format.json { head :no_content }
    end
  end
end
