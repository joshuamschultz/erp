class MaterialElementsController < ApplicationController
  # GET /material_elements
  # GET /material_elements.json
  def index
    @material = Material.find(params[:material_id])
    @material_elements = @material.material_elements

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @material_elements = @material_elements.select{|element| 
            element[:links] = CommonActions.object_crud_paths(material_material_element_path(@material, element), 
                              edit_material_material_element_path(@material, element), 
                              material_material_element_path(@material, element)
                            )
        }
        material_elements = {:aaData => @material_elements}
        render json: material_elements
      }
    end
  end

  # GET /material_elements/1
  # GET /material_elements/1.json
  def show
    @material = Material.find(params[:material_id])
    @material_element = @material.material_elements.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @material_element }
    end
  end

  # GET /material_elements/new
  # GET /material_elements/new.json
  def new
    @material = Material.find(params[:material_id])
    @material_element = MaterialElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material_element }
    end
  end

  # GET /material_elements/1/edit
  def edit
    @material = Material.find(params[:material_id])
    @material_element = @material.material_elements.find(params[:id])
  end

  # POST /material_elements
  # POST /material_elements.json
  def create
    @material = Material.find(params[:material_id])
    @material_element = MaterialElement.new(params[:material_element])

    respond_to do |format|
      if @material_element.save
        format.html { redirect_to material_material_element_path(@material, @material_element), notice: 'Material element was successfully created.' }
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
    @material = Material.find(params[:material_id])
    @material_element = @material.material_elements.find(params[:id])

    respond_to do |format|
      if @material_element.update_attributes(params[:material_element])
        format.html { redirect_to material_material_element_path(@material, @material_element), notice: 'Material element was successfully updated.' }
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
    @material = Material.find(params[:material_id])
    @material_element = @material.material_elements.find(params[:id])
    @material_element.destroy

    respond_to do |format|
      format.html { redirect_to material_material_elements_path(@material) }
      format.json { head :no_content }
    end
  end
end
