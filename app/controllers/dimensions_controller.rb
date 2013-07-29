class DimensionsController < ApplicationController
  # GET /dimensions
  # GET /dimensions.json
  def index
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @dimensions = @dimensions.select{|dimension|
          dimension[:links] = CommonActions.object_crud_paths(organization_gauge_dimension_path(@organizations,@gauges,dimension),
                              edit_organization_gauge_dimension_path(@organizations,@gauges,dimension),
                              organization_gauge_dimension_path(@organizations,@gauges,dimension)
            )}
        render json: {:aaData => @dimensions} 
      }
    end
  end

  # GET /dimensions/1
  # GET /dimensions/1.json
  def show
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/new
  # GET /dimensions/new.json
  def new
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/1/edit
  def edit
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.find(params[:id])
  end

  # POST /dimensions
  # POST /dimensions.json
  def create
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.create(params[:dimension])

    respond_to do |format|
      if @dimensions.save
        format.html { redirect_to organization_gauge_dimensions_path(@organizations,@gauges), notice: 'Dimension was successfully created.' }
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
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.find(params[:id])

    respond_to do |format|
      if @dimensions.update_attributes(params[:dimension])
        format.html { redirect_to organization_gauge_dimensions_path(@organizations,@gauges), notice: 'Dimension was successfully updated.' }
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
    @organizations = Organization.find(params[:organization_id])
    @gauges = @organizations.gauges.find(params[:gauge_id])
    @dimensions = @gauges.dimensions.find(params[:id])
    @dimensions.destroy

    respond_to do |format|
      format.html { redirect_to organization_gauge_dimensions_path(@organizations,@gauges), notice: 'Dimension was successfully updated.' }
      format.json { head :no_content }
    end
  end
end
