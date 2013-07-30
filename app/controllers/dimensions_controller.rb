class DimensionsController < ApplicationController
  # GET /dimensions
  # GET /dimensions.json
  def index
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimensions = @gauge.dimensions.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @dimensions = @dimensions.select{|dimension|
          dimension[:dimension_identifier] = "<a href='#{organization_gauge_dimension_path(@organization, @gauge, dimension)}'>#{dimension[:dimension_identifier]}</a>"
          dimension[:links] = CommonActions.object_crud_paths(nil, edit_organization_gauge_dimension_path(@organization, @gauge, dimension), nil)
      }
        render json: {:aaData => @dimensions} 
      }
    end
  end

  # GET /dimensions/1
  # GET /dimensions/1.json
  def show
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimension = @gauge.dimensions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/new
  # GET /dimensions/new.json
  def new
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimension = @gauge.dimensions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/1/edit
  def edit
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimension = @gauge.dimensions.find(params[:id])
  end

  # POST /dimensions
  # POST /dimensions.json
  def create
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimension = @gauge.dimensions.new(params[:dimension])

    respond_to do |format|
      if @dimension.save
        format.html { redirect_to organization_gauge_dimensions_path(@organization, @gauge), notice: 'Dimension was successfully created.' }
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
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimension = @gauge.dimensions.find(params[:id])

    respond_to do |format|
      if @dimension.update_attributes(params[:dimension])
        format.html { redirect_to organization_gauge_dimensions_path(@organization, @gauge), notice: 'Dimension was successfully updated.' }
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
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:gauge_id])
    @dimension = @gauge.dimensions.find(params[:id])
    @dimension.destroy

    respond_to do |format|
      format.html { redirect_to organization_gauge_dimensions_path(@organization, @gauge), notice: 'Dimension was successfully updated.' }
      format.json { head :no_content }
    end
  end
end
