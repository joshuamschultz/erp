class MaterialElementsController < ApplicationController
  before_action :set_material_and_material_element, only: %i[show edit update destroy]
  before_action :set_page_info
  before_action :set_autocomplete_values, only: %i[create update]

  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions

  # GET /material_elements
  # GET /material_elements.json
  def index
    @material = Material.find(params[:material_id])
    @material_elements = @material.material_elements.all

    respond_to do |format|
      format.html # index.html.erb
      @material_elemens = []
      format.json do
        @material_elements = @material_elements.select do |element|
          elemend = {}
          element.attributes.each do |key, value|
            elemend[key] = value
          end
          elemend[:element_name] = CommonActions.linkable(element_path(element.element), element.element.element_name)
          elemend[:element_symbol] = element.element.element_symbol

          if can? :edit, MaterialElement

            elemend[:links] = CommonActions.object_crud_paths(material_material_element_path(@material, element),
                                                              edit_material_material_element_path(@material, element),
                                                              material_material_element_path(@material, element))
          else
            elemend[:links] = CommonActions.object_crud_paths(material_material_element_path(@material, element),
                                                              nil,
                                                              nil)
          end
          @material_elemens.push(elemend)
        end
        render json: { aaData: @material_elemens }
      end
    end
  end

  # GET /material_elements/1
  # GET /material_elements/1.json
  def show; end

  # GET /material_elements/new
  # GET /material_elements/new.json
  def new
    @material = Material.find(params[:material_id])
    @duplicate = MaterialElement.find_by_id(params[:element_id])
    @material_element = @duplicate.present? ? @duplicate.dup : MaterialElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material_element }
    end
  end

  # GET /material_elements/1/edit
  def edit; end

  # POST /material_elements
  # POST /material_elements.json
  def create
    @material = Material.find(params[:material_id])
    @material_element = MaterialElement.new(material_element_params)

    respond_to do |format|
      if @material_element.save
        format.html { redirect_to material_material_elements_path(@material), notice: 'Material element was successfully created.' }
        # material_material_element_path(@material, @material_element)
        format.json { render json: @material_element, status: :created, location: @material_element }
      else
        format.html { render action: 'new' }
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
      if @material_element.update_attributes(material_element_params)
        format.html { redirect_to material_material_elements_path(@material), notice: 'Material element was successfully updated.' }
        # material_material_element_path(@material, @material_element)
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @material_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /material_elements/1
  # DELETE /material_elements/1.json
  def destroy
    @material_element.destroy
  end

  def set_autocomplete_values
    params[:material_element][:element_id], params[:element_id] = params[:element_id], params[:material_element][:element_id]
    params[:material_element][:element_id] = params[:org_element_id] if params[:material_element][:element_id] == ''
  end

  def view_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, MaterialElement
    end
  end

  def user_permissions
    if user_signed_in? && (current_user.is_logistics? || current_user.is_clerical?)
      authorize! :edit, MaterialElement
    end
  end

  def set_page_info
    @menus[:inventory][:active] = 'active'
  end

  private

  def set_material_and_material_element
    @material = Material.find(params[:material_id])
    @material_element = @material.material_elements.find(params[:id])
  end

  def material_element_params
    params.require(:material_element).permit(:material_id, :element_active, :element_created_id,
                                             :element_high_range, :element_low_range, :element_name, :element_symbol,
                                             :element_updated_id, :element_id)
  end
end
