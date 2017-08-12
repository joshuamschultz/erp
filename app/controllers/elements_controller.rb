class ElementsController < ApplicationController
  before_action :set_element, only: %i[show edit update destroy]
  before_action :set_page_info
  before_action :user_permissions

  autocomplete :element, :element_name, full: true, display_value: :element_symbol_name

  # GET /elements
  # GET /elements.json
  def index
    @elements = Element.all
  end

  # GET /elements/1
  # GET /elements/1.json
  def show; end

  # GET /elements/new
  # GET /elements/new.json
  def new
    @element = Element.new
  end

  # GET /elements/1/edit
  def edit; end

  # POST /elements
  # POST /elements.json
  def create
    @element = Element.new(element_params)
    @element.save
    respond_with @element
  end

  # PUT /elements/1
  # PUT /elements/1.json
  def update
    @element.update_attributes(element_params)
    respond_with @element
  end

  # DELETE /elements/1
  # DELETE /elements/1.json
  def destroy
    @element.destroy
    respond_with :elements
  end

  def get_autocomplete_items(parameters)
    items = active_record_get_autocomplete_items(parameters)
    input_term = '%' + params[:term] + '%'
    items = Element.where('element_name like ? or element_symbol like ?', input_term, input_term)
  end

  # def view_permissions
  #  if  user_signed_in? && current_user.is_customer?
  #       authorize! :edit, Element
  #   end
  # end

  def user_permissions
    if user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? || current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, Element
    end
  end

  def set_page_info
    @menus[:inventory][:active] = 'active'
  end

  private

  def set_element
    @element = Element.find(params[:id])
  end

  def element_params
    params.require(:element).permit(:element_active, :element_name, :element_notes, :element_symbol)
  end
end
