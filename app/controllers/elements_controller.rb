class ElementsController < ApplicationController
  before_filter :set_page_info
  autocomplete :element, :element_name, :full => true, :display_value => :element_symbol_name
  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, Element
    end 
  end

  def user_permissions
   if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? )
        authorize! :edit, Element
    end 
  end
  def set_page_info
    @menus[:inventory][:active] = "active"
  end

  def get_autocomplete_items(parameters)
    items = super(parameters)  
    input_term = "%" + params[:term] + "%"
    items = Element.where("element_name like ? or element_symbol like ?", input_term, input_term)
  end

  # GET /elements
  # GET /elements.json
  def index
    @elements = Element.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { @elements.select{ |element|
        element[:element_name] = "<a href='#{element_path(element)}'>#{element[:element_name]}</a>"
        if can? :edit, element
          element[:links] = CommonActions.object_crud_paths(nil, edit_element_path(element), nil)
        else
          element[:links] = nil
        end
        }
        render json: {:aaData => @elements} 
      }
    end
  end

  # GET /elements/1
  # GET /elements/1.json
  def show
    @element = Element.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @element }
    end
  end

  # GET /elements/new
  # GET /elements/new.json
  def new
    @element = Element.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @element }
    end
  end

  # GET /elements/1/edit
  def edit
    @element = Element.find(params[:id])
  end

  # POST /elements
  # POST /elements.json
  def create
    @element = Element.new(params[:element])

    respond_to do |format|
      if @element.save
        format.html { redirect_to elements_path, notice: 'Element was successfully created.' }
        format.json { render json: @element, status: :created, location: @element }
      else
        format.html { render action: "new" }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /elements/1
  # PUT /elements/1.json
  def update
    @element = Element.find(params[:id])

    respond_to do |format|
      if @element.update_attributes(params[:element])
        format.html { redirect_to elements_path, notice: 'Element was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elements/1
  # DELETE /elements/1.json
  def destroy
    @element = Element.find(params[:id])
    @element.destroy

    respond_to do |format|
      format.html { redirect_to elements_url }
      format.json { head :no_content }
    end
  end
end
