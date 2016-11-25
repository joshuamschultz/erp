class TerritoriesController < ApplicationController
  before_filter :set_page_info
  before_filter :check_permissions
  def set_page_info
      @menus[:system][:active] = "active"
  end

  def check_permissions
        authorize! :view, Territory
  end
  
  # GET /territories
  # GET /territories.json
  def index
    @territories = Territory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @territories = @territories.select{|territory| 
          territory[:links] = CommonActions.object_crud_paths(territory_path(territory), edit_territory_path(territory), 
                        territory_path(territory))
        }
        render json: {:aaData => @territories} 
      }
    end
  end

  # GET /territories/1
  # GET /territories/1.json
  def show
    @territory = Territory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @territory }
    end
  end

  # GET /territories/new
  # GET /territories/new.json
  def new
    @territory = Territory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @territory }
    end
  end

  # GET /territories/1/edit
  def edit
    @territory = Territory.find(params[:id])
  end

  # POST /territories
  # POST /territories.json
  def create
    @territory = Territory.new(params[:territory])

    respond_to do |format|
      if @territory.save
        format.html { redirect_to territories_url, notice: 'Territory was successfully created.' }
        format.json { render json: @territory, status: :created, location: @territory }
      else
        format.html { render action: "new" }
        format.json { render json: @territory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /territories/1
  # PUT /territories/1.json
  def update
    @territory = Territory.find(params[:id])

    respond_to do |format|
      if @territory.update_attributes(params[:territory])
        format.html { redirect_to territories_url, notice: 'Territory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @territory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /territories/1
  # DELETE /territories/1.json
  def destroy
    @territory = Territory.find(params[:id])
    @territory.destroy

    respond_to do |format|
      format.html { redirect_to territories_url }
      format.json { head :no_content }
    end
  end
   private

    def set_territory
      @territory = Territory.find(params[:id])
    end

    def territory_params
      params.require(:territory).permit(:territory_active, :territory_created_id, :territory_description,
                                        :territory_identifier, :territory_updated_id, :territory_zip)
    end
end
