class MaterialsController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @materials = @materials.select{|material| 
            material[:links] = CommonActions.object_crud_paths(material_path(material), 
                              edit_material_path(material), material_path(material),
                              [ {:name => "Elements", :path => material_material_elements_path(material)},
                                {:name => "Duplicate", :path => new_material_path(:material_id => material.id)}
                              ])
        }
        render json: {:aaData => @materials}
      }
    end
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
    @material = Material.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @material }
    end
  end

  # GET /materials/new
  # GET /materials/new.json
  def new
    @duplicate = Material.find_by_id(params[:material_id])
    @material = @duplicate.present? ? @duplicate.dup : Material.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material }
    end
  end

  # GET /materials/1/edit
  def edit
    @material = Material.find(params[:id])
  end

  # POST /materials
  # POST /materials.json
  def create
    @duplicate = Material.find_by_id(params[:material_id])
    @material = Material.new(params[:material])   

    respond_to do |format|
      if @material.valid?        
        @material.material_elements = @duplicate.material_elements.collect{|element| new_element = element.dup } if @duplicate
        @material.save
        format.html { redirect_to materials_url, notice: 'Material was successfully created.' }
        format.json { render json: @material, status: :created, location: @material }
      else
        format.html { render action: "new" }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /materials/1
  # PUT /materials/1.json
  def update
    @material = Material.find(params[:id])

    respond_to do |format|
      if @material.update_attributes(params[:material])
        format.html { redirect_to materials_url, notice: 'Material was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material = Material.find(params[:id])
    @material.destroy

    respond_to do |format|
      format.html { redirect_to materials_url }
      format.json { head :no_content }
    end
  end
end
