class MaterialsController < ApplicationController
  before_action :set_page_info

  autocomplete :material, :material_short_name, :full => true
  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, Material
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? )
        authorize! :edit, Material
    end
  end
  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all

    respond_to do |format|
      format.html # index.html.erb
      @materils = Array.new
      format.json {
        @materials = @materials.select{|material|
          materil = Hash.new
          material.attributes.each do |key, value|
            materil[key] = value
          end
          if can? :edit,  material

            materil[:links] = CommonActions.object_crud_paths(material_path(material),
                              edit_material_path(material), material_path(material),
                              [ {:name => "Elements", :path => material_material_elements_path(material)},
                                {:name => "Duplicate", :path => new_material_path(:material_id => material.id)}
                              ])
          else
            materil[:links] = CommonActions.object_crud_paths(material_path(material),
                              nil, nil,
                              [ {:name => "Elements", :path => material_material_elements_path(material)},

                              ])
          end
          @materils.push(materil)
        }
        render json: {:aaData => @materils}
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
    @material = Material.new(material_params)

    respond_to do |format|
      if @material.valid?
        if @duplicate
          @duplicate.material_elements.each do |element|
              new_element = element.dup
              new_element.material_id = @material.id
              @material.material_elements << new_element
          end
        end
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
      if @material.update_attributes(material_params)
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
  private

    def set_material
      @material = Material.find(params[:id])
    end

    def material_params
      params.require(:material).permit(:material_active, :material_created_id,
                                       :material_description, :material_notes,
                                       :material_short_name, :material_updated_id)
    end

end
