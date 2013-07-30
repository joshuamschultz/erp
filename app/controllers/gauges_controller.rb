class GaugesController < ApplicationController
  # GET /gauges
  # GET /gauges.json
  def index
    @organization = Organization.find(params[:organization_id])
    @gauges = @organization.gauges.all
    respond_to do |format|
      format.html # index.html.erb
      format.json{
        @gauges = @gauges.select{|gauge|
          gauge[:gauge_tool_name] = "<a href='#{organization_gauge_path(@organization, gauge)}'>#{gauge[:gauge_tool_name]}</a>"
          gauge[:links] = CommonActions.object_crud_paths(nil, edit_organization_gauge_path(@organization,gauge), nil, 
            [ {:name => "Dimensions", :path => organization_gauge_dimensions_path(@organization, gauge)}
            ])
        }
        render json: {:aaData => @gauges}
      }
    end
  end

  # GET /gauges/1
  # GET /gauges/1.json
  def show
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gauge }
    end
  end

  # GET /gauges/new
  # GET /gauges/new.json
  def new
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gauge }
    end
  end

  # GET /gauges/1/edit
  def edit
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:id])
  end

  # POST /gauges
  # POST /gauges.json
  def create
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.create(params[:gauge])

    respond_to do |format|
      if @gauge.save
        format.html { redirect_to organization_gauges_path(@organization), notice: 'Gauge was successfully created.' }
        format.json { render json: @gauge, status: :created, location: @gauge }
      else
        format.html { render action: "new" }
        format.json { render json: @gauge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gauges/1
  # PUT /gauges/1.json
  def update
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:id])

    respond_to do |format|
      if @gauge.update_attributes(params[:gauge])
        format.html { redirect_to organization_gauges_path(@organization), notice: 'Gauge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gauge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gauges/1
  # DELETE /gauges/1.json
  def destroy
    @organization = Organization.find(params[:organization_id])
    @gauge = @organization.gauges.find(params[:id])
    @gauge.destroy

    respond_to do |format|
      format.html { redirect_to organization_gauges_path(@organization)}
      format.json { head :no_content }
    end
  end
end
