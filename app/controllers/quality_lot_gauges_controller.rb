class QualityLotGaugesController < ApplicationController
  # GET /quality_lot_gauges
  # GET /quality_lot_gauges.json
  def index
    @quality_lot_gauges = QualityLotGauge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quality_lot_gauges }
    end
  end

  # GET /quality_lot_gauges/1
  # GET /quality_lot_gauges/1.json
  def show
    @quality_lot_gauge = QualityLotGauge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_lot_gauge }
    end
  end

  # GET /quality_lot_gauges/new
  # GET /quality_lot_gauges/new.json
  def new
    @quality_lot_gauge = QualityLotGauge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_lot_gauge }
    end
  end

  # GET /quality_lot_gauges/1/edit
  def edit
    @quality_lot_gauge = QualityLotGauge.find(params[:id])
  end

  # POST /quality_lot_gauges
  # POST /quality_lot_gauges.json
  def create
    @quality_lot_gauge = QualityLotGauge.new(params[:quality_lot_gauge])

    respond_to do |format|
      if @quality_lot_gauge.save
        format.html { redirect_to @quality_lot_gauge, notice: 'Quality lot gauge was successfully created.' }
        format.json { render json: @quality_lot_gauge, status: :created, location: @quality_lot_gauge }
      else
        format.html { render action: "new" }
        format.json { render json: @quality_lot_gauge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_lot_gauges/1
  # PUT /quality_lot_gauges/1.json
  def update
    @quality_lot_gauge = QualityLotGauge.find(params[:id])

    respond_to do |format|
      if @quality_lot_gauge.update_attributes(params[:quality_lot_gauge])
        format.html { redirect_to @quality_lot_gauge, notice: 'Quality lot gauge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_lot_gauge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_lot_gauges/1
  # DELETE /quality_lot_gauges/1.json
  def destroy
    @quality_lot_gauge = QualityLotGauge.find(params[:id])
    @quality_lot_gauge.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_gauges_url }
      format.json { head :no_content }
    end
  end
end
