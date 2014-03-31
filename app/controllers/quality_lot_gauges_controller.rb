class QualityLotGaugesController < ApplicationController
  # GET /quality_lot_gauges
  # GET /quality_lot_gauges.json
  def index
    @quality_lot = QualityLot.find(params[:quality_lot_id]) if params[:quality_lot_id]
    @quality_lot = QualityLot.first unless @quality_lot
    if @quality_lot
        @item_revision = @quality_lot.item_revision
        @item = @item_revision.item
        @quality_lot_gauges = @quality_lot.quality_lot_gauges
    else
        @quality_lot_gauges = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quality_lot_gauges }
    end
  end

  # GET /quality_lot_gauges/1
  # GET /quality_lot_gauges/1.json
  def show
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_gauge = QualityLotGauge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_lot_gauge }
    end
  end

  # GET /quality_lot_gauges/new
  # GET /quality_lot_gauges/new.json
  def new
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    if @quality_lot.quality_lot_gauges.any?
        redirect_to edit_quality_lot_gauge_path(@quality_lot.quality_lot_gauges.first, quality_lot_id: @quality_lot.id)
    else      
        @quality_lot_gauge = QualityLotGauge.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @quality_lot_gauge }
        end
    end
  end

  # GET /quality_lot_gauges/1/edit
  def edit
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_gauge = QualityLotGauge.find(params[:id])
  end

  # POST /quality_lot_gauges
  # POST /quality_lot_gauges.json
  def create
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_gauge = QualityLotGauge.new(params[:quality_lot_gauge])

    respond_to do |format|
      if @quality_lot_gauge.save
        QualityLotGauge.process_gauge_dimensions(@quality_lot_gauge, params)
        format.html { redirect_to(new_quality_lot_gauge_quality_lot_gauge_result_path(@quality_lot_gauge, appraisor: 1), notice: 'Quality lot gauge was successfully created.') }
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
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_gauge = QualityLotGauge.find(params[:id])

    respond_to do |format|
      if @quality_lot_gauge.update_attributes(params[:quality_lot_gauge])
        QualityLotGauge.process_gauge_dimensions(@quality_lot_gauge, params)
        format.html { redirect_to(new_quality_lot_gauge_quality_lot_gauge_result_path(@quality_lot_gauge, appraisor: 1), notice: 'Quality lot gauge was successfully updated.') }
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
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @quality_lot_gauge = QualityLotGauge.find(params[:id])
    @quality_lot_gauge.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_gauges_url }
      format.json { head :no_content }
    end
  end
end
