class CommoditiesController < ApplicationController
  before_action :set_page_info

  autocomplete :commodity, :commodity_identifier, :full => true

  def set_page_info
      @menus[:system][:active] = "active"
  end

  # GET /commodities
  # GET /commodities.json
  def index
    @commodities = Commodity.all

    respond_to do |format|
      format.html # index.html.erb
      @commoditis = Array.new
      format.json {
        @commodities = @commodities.select{|commodity|
          commoditi = Hash.new
          commodity.attributes.each do |key, value|
            commoditi[key] = value
          end
          commoditi[:links] = CommonActions.object_crud_paths(commodity_path(commodity), edit_commodity_path(commodity),
                        commodity_path(commodity))
          @commoditis.push(commoditi)
        }
        render json: {:aaData => @commoditis}
      }
    end
  end

  # GET /commodities/1
  # GET /commodities/1.json
  def show
    @commodity = Commodity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @commodity }
    end
  end

  # GET /commodities/new
  # GET /commodities/new.json
  def new
    @commodity = Commodity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @commodity }
    end
  end

  # GET /commodities/1/edit
  def edit
    @commodity = Commodity.find(params[:id])
  end

  # POST /commodities
  # POST /commodities.json
  def create
    @commodity = Commodity.new(commodity_params)

    respond_to do |format|
      if @commodity.save
        format.html { redirect_to commodities_url, notice: 'Commodity was successfully created.' }
        format.json { render json: @commodity, status: :created, location: @commodity }
      else
        format.html { render action: "new" }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /commodities/1
  # PUT /commodities/1.json
  def update
    @commodity = Commodity.find(params[:id])

    respond_to do |format|
      if @commodity.update_attributes(commodity_params)
        format.html { redirect_to commodities_url, notice: 'Commodity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commodities/1
  # DELETE /commodities/1.json
  def destroy
    @commodity = Commodity.find(params[:id])
    @commodity.destroy

    respond_to do |format|
      format.html { redirect_to commodities_url }
      format.json { head :no_content }
    end
  end
  private

    def set_commodity
      @commodity = Commodity.find(params[:id])
    end

    def commodity_params
      params.require(:commodity).permit(:commodity_active, :commodity_created_id, :commodity_description,
      :commodity_identifier, :commodity_notes, :commodity_updated_id)
    end
end
