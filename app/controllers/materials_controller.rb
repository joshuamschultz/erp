class MaterialsController < ApplicationController
  before_action :set_page_info
  before_action :set_material, only: %i[show edit update destroy]

  autocomplete :material, :material_short_name, full: true
  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions

  def view_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, Material
    end
  end

  def user_permissions
    if user_signed_in? && (current_user.is_logistics? || current_user.is_clerical?)
      authorize! :edit, Material
    end
  end

  def set_page_info
    @menus[:inventory][:active] = 'active'
  end

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all

    respond_to do |format|
      format.html # index.html.erb
      @materils = []
      format.json do
        @materials = @materials.select do |material|
          materil = {}
          material.attributes.each do |key, value|
            materil[key] = value
          end
          if can? :edit, material

            materil[:links] = CommonActions.object_crud_paths(material_path(material),
                                                              edit_material_path(material), material_path(material),
                                                              [{ name: 'Elements', path: material_material_elements_path(material) },
                                                               { name: 'Duplicate', path: new_material_path(material_id: material.id) }])
          else
            materil[:links] = CommonActions.object_crud_paths(material_path(material),
                                                              nil, nil,
                                                              [{ name: 'Elements', path: material_material_elements_path(material) }])
          end
          @materils.push(materil)
        end
        render json: { aaData: @materils }
      end
    end
  end

  # GET /materials/1
  # GET /materials/1.json
  def show; end

  # GET /materials/new
  # GET /materials/new.json
  def new
    @duplicate = Material.find_by_id(params[:material_id])
    @material = @duplicate.present? ? @duplicate.dup : Material.new
  end

  # GET /materials/1/edit
  def edit; end

  # POST /materials
  # POST /materials.json
  def create
    @duplicate = Material.find_by_id(params[:material_id])
    @material = Material.new(material_params)

    if @material.valid?
      if @duplicate
        @duplicate.material_elements.each do |element|
          new_element = element.dup
          new_element.material_id = @material.id
          @material.material_elements << new_element
        end
      end
      @material.save
    end
    if @duplicate
      respond_with :materials
    else
      respond_with @material
    end
  end

  # PUT /materials/1
  # PUT /materials/1.json
  def update
    @material.update_attributes(material_params)
    respond_with @material
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    resond_with :materials
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:material_active, :material_created_id,
                                     :material_description, :material_notes,
                                     :material_short_name, :material_updated_id, elements: %i[id element_active element_name element_notes element_symbol _destroy],
                                                                                 material_elements_attributes: %i[id element_symbol material_id element_id element_high_range element_low_range _destroy])
  end
end
