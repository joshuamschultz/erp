class QualityLotGaugeResultsController < ApplicationController
  # GET quality_lot_gauges/1/quality_lot_gauge_results
  # GET quality_lot_gauges/1/quality_lot_gauge_results.json
  def index
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_results = @quality_lot_gauge.quality_lot_gauge_results.order(:item_part_dimension_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          all_gauge_results = process_gauge_results(@quality_lot_gauge_results.where(lot_gauge_result_appraiser: 1).group(:item_part_dimension_id))
          all_gauge_results += process_gauge_results(@quality_lot_gauge_results.where(lot_gauge_result_appraiser: 2).group(:item_part_dimension_id))
          all_gauge_results += process_gauge_results(@quality_lot_gauge_results.where(lot_gauge_result_appraiser: 3).group(:item_part_dimension_id))
          render json: { :aaData => all_gauge_results } 
      }
    end
  end


  def process_gauge_results(quality_lot_gauge_results)
      quality_lot_gauge_results.each do |lot_gauge|    
        lot_gauge[:lot_gauge_appraisor] = "Appraisor" + lot_gauge.lot_gauge_result_appraiser
        lot_gauge[:item_part_letter] = CommonActions.linkable(item_item_revision_item_part_dimension_path(lot_gauge.item_part_dimension.item_revision.item, lot_gauge.item_part_dimension.item_revision, lot_gauge.item_part_dimension), lot_gauge.item_part_dimension.item_part_letter)
        lot_gauge[:item_part_dimensions] = lot_gauge.item_part_dimension.item_part_dimension.round(4)
        lot_gauge[:item_part_pos_tolerance] = (lot_gauge.item_part_dimension.item_part_dimension + lot_gauge.item_part_dimension.item_part_pos_tolerance).round(4)
        lot_gauge[:item_part_neg_tolerance] = (lot_gauge.item_part_dimension.item_part_dimension - lot_gauge.item_part_dimension.item_part_neg_tolerance).round(4)
        lot_gauge[:lot_gauge_avg] = (lot_gauge.all_lot_gauges.sum(:lot_gauge_result_value)/lot_gauge.all_lot_gauges.count).round(4) rescue 0
        
        lot_gauge_values = []
        lot_gauge.all_lot_gauges.collect(&:lot_gauge_result_value).each do |value|
            lot_gauge_values << value.to_f
        end

        lot_gauge[:lot_gauge_std] = lot_gauge_values.stdev.round(4) rescue 0
        lot_gauge[:lot_gauge_max] = lot_gauge.all_lot_gauges.maximum(:lot_gauge_result_value).round(4)
        lot_gauge[:lot_gauge_min] = lot_gauge.all_lot_gauges.minimum(:lot_gauge_result_value).round(4)
        lot_gauge[:lot_gauge_status] = ""
      end
  end

  # GET quality_lot_gauges/1/quality_lot_gauge_results/1
  # GET quality_lot_gauges/1/quality_lot_gauge_results/1.json
  def show
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_result = @quality_lot_gauge.quality_lot_gauge_results.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quality_lot_gauge_result }
    end
  end

  # GET quality_lot_gauges/1/quality_lot_gauge_results/new
  # GET quality_lot_gauges/1/quality_lot_gauge_results/new.json
  def new
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_result = @quality_lot_gauge.quality_lot_gauge_results.build
    params[:appraisor] ||= "1"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quality_lot_gauge_result }
    end
  end

  # GET quality_lot_gauges/1/quality_lot_gauge_results/1/edit
  def edit
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_result = @quality_lot_gauge.quality_lot_gauge_results.find(params[:id])
  end

  # POST quality_lot_gauges/1/quality_lot_gauge_results
  # POST quality_lot_gauges/1/quality_lot_gauge_results.json
  def create
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_result = @quality_lot_gauge.quality_lot_gauge_results.build(params[:quality_lot_gauge_result])

    respond_to do |format|
      if @quality_lot_gauge_result.save
        @quality_lot_gauge.process_quality_lot_gauges(params)
        @quality_lot_gauge.quality_lot_gauge_results.group(:item_part_dimension_id, :lot_gauge_result_appraiser).each{|result| result.process_after_save }
        format.html { redirect_to(new_quality_lot_gauge_quality_lot_gauge_result_path(@quality_lot_gauge, :appraisor => params[:appraisor]), :notice => 'Quality lot gauge analysis was successfully updated.') }
        format.json { render :json => @quality_lot_gauge_result, :status => :created, :location => [@quality_lot_gauge_result.quality_lot_gauge, @quality_lot_gauge_result] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @quality_lot_gauge_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT quality_lot_gauges/1/quality_lot_gauge_results/1
  # PUT quality_lot_gauges/1/quality_lot_gauge_results/1.json
  def update
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_result = @quality_lot_gauge.quality_lot_gauge_results.find(params[:id])

    respond_to do |format|
      if @quality_lot_gauge_result.update_attributes(params[:quality_lot_gauge_result])
        format.html { redirect_to(edit_quality_lot_gauge_path(@quality_lot_gauge, quality_lot_id: @quality_lot_gauge.quality_lot_id), :notice => 'Quality lot gauge result was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @quality_lot_gauge_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE quality_lot_gauges/1/quality_lot_gauge_results/1
  # DELETE quality_lot_gauges/1/quality_lot_gauge_results/1.json
  def destroy
    @quality_lot_gauge = QualityLotGauge.find(params[:quality_lot_gauge_id])
    @quality_lot_gauge_result = @quality_lot_gauge.quality_lot_gauge_results.find(params[:id])
    @quality_lot_gauge_result.destroy

    respond_to do |format|
      format.html { redirect_to quality_lot_gauge_quality_lot_gauge_results_url(quality_lot_gauge) }
      format.json { head :ok }
    end
  end
end
