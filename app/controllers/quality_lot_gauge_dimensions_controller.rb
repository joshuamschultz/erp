class QualityLotGaugeDimensionsController < ApplicationController
  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions
  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions.json
  def index
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimensions = @quality_lot_gauge.quality_lot_gauge_dimensions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @quality_lot_gauge_dimensions }
    end
  end

  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions/1
  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions/1.json
  def show
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimension = @quality_lot_gauge.quality_lot_gauge_dimensions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quality_lot_gauge_dimension }
    end
  end

  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions/new
  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions/new.json
  def new
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimension = @quality_lot_gauge.quality_lot_gauge_dimensions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quality_lot_gauge_dimension }
    end
  end

  # GET quality_lot_gauges/1/quality_lot_gauge_dimensions/1/edit
  def edit
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimension = @quality_lot_gauge.quality_lot_gauge_dimensions.find(params[:id])
  end

  # POST quality_lot_gauges/1/quality_lot_gauge_dimensions
  # POST quality_lot_gauges/1/quality_lot_gauge_dimensions.json
  def create
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimension = @quality_lot_gauge.quality_lot_gauge_dimensions.build(params[:quality_lot_gauge_dimension])

    respond_to do |format|
      if @quality_lot_gauge_dimension.save
        format.html { redirect_to([@quality_lot_gauge_dimension.quality_lot_gauge, @quality_lot_gauge_dimension], :notice => 'Quality lot gauge dimension was successfully created.') }
        format.json { render :json => @quality_lot_gauge_dimension, :status => :created, :location => [@quality_lot_gauge_dimension.quality_lot_gauge, @quality_lot_gauge_dimension] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @quality_lot_gauge_dimension.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT quality_lot_gauges/1/quality_lot_gauge_dimensions/1
  # PUT quality_lot_gauges/1/quality_lot_gauge_dimensions/1.json
  def update
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimension = @quality_lot_gauge.quality_lot_gauge_dimensions.find(params[:id])

    respond_to do |format|
      if @quality_lot_gauge_dimension.update_attributes(params[:quality_lot_gauge_dimension])
        format.html { redirect_to([@quality_lot_gauge_dimension.quality_lot_gauge, @quality_lot_gauge_dimension], :notice => 'Quality lot gauge dimension was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @quality_lot_gauge_dimension.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE quality_lot_gauges/1/quality_lot_gauge_dimensions/1
  # DELETE quality_lot_gauges/1/quality_lot_gauge_dimensions/1.json
  def destroy
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_dimension = @quality_lot_gauge.quality_lot_gauge_dimensions.find(params[:id])
    @quality_lot_gauge_dimension.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_gauge_quality_lot_gauge_dimensions_url(quality_lot_gauge) }
      format.json { head :ok }
    end
  end
end
