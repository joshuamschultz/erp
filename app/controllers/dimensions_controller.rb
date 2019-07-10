class DimensionsController < ApplicationController
  before_action :set_page_info
  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && current_user.is_vendor?
      authorize! :edit, Dimension
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? || current_user.is_customer? )
      authorize! :edit, Dimension
    end
  end
  def set_page_info
      @menus[:quality][:active] = "active"
  end

  # GET /dimensions
  # GET /dimensions.json
  def index
    @dimensions = Dimension.all
    @dimnsions = Array.new
    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @dimensions = @dimensions.select{|dimension|
          dimnsion = Hash.new
          dimension.attributes.each do |key, value|
            dimnsion[key] = value
          end
          dimnsion[:dimension_identifier] = "<a href='#{dimension_path(dimension)}'>#{dimension[:dimension_identifier]}</a>"
          # dimension[:instrument_name] = "<a href='#{gauge_path(dimension.gauge)}'>#{dimension.gauge.gauge_tool_name}</a>"
          if can? :edit, Dimension
            dimnsion[:links] = CommonActions.object_crud_paths(nil, nil, nil)
          else
            dimnsion[:links] = CommonActions.object_crud_paths(nil, nil, nil)
          end
          @dimnsions.push(dimnsion)
      }

        render json: {:aaData => @dimnsions}
      }
    end
  end

  # GET /dimensions/1
  # GET /dimensions/1.json
  def show
    @dimension = Dimension.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/new
  # GET /dimensions/new.json
  def new
    @dimension = Dimension.new
    @item = Item.find_by_id(params[:item_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/1/edit
  def edit
    @dimension = Dimension.find(params[:id])
  end

  # POST /dimensions
  # POST /dimensions.json
  def create

    @dimension = Dimension.new(dimension_params)

    respond_to do |format|
      if @dimension.save!
        format.html {
            item = Item.find_by_id(params[:item_id])
            if item
                redirect_to item_path(item), notice: 'Dimension type was successfully created.'
            else
                redirect_to dimensions_path, notice: 'Dimension type was successfully created.'
            end
        }
        format.json { render json: @dimension, status: :created, location: @dimension }
      else
        format.html { render action: "new" }
        format.json { render json: @dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dimensions/1
  # PUT /dimensions/1.json
  def update
    @dimension = Dimension.find(params[:id])

    respond_to do |format|
      if @dimension.update_attributes(dimension_params)
        format.html { redirect_to dimensions_path, notice: 'Dimension type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dimensions/1
  # DELETE /dimensions/1.json
  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    respond_to do |format|
      format.html { redirect_to dimensions_path, notice: 'Dimension was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  private

    def set_dimension
      @dimension = Dimension.find(params[:id])
    end

    def dimension_params
      params.require(:dimension).permit(:dimension_active, :dimension_created_id, :dimension_description,
                                                :dimension_identifier, :dimension_notes, :dimension_updated_id, :gauge_id)
    end
end
