class QualityLotGaugeResult < ActiveRecord::Base
  belongs_to :quality_lot_gauge
  belongs_to :item_part_dimension

  attr_accessible :lot_gauge_result_appraiser, :lot_gauge_result_value, :quality_lot_gauge_id, 
  :item_part_dimension_id, :lot_gauge_result_status, :lot_gauge_result_trial, :lot_gauge_result_row

  @@gauge_app = 3
  @@gauge_trails = 3
  @@gauge_k1 = 3.05
  @@gauge_k2 = 2.7
  @@gauge_k3 = 1.62
  @@gauge_d4 = 2.58
  @@gauge_n = 10


  # validates_presence_of :item_part_dimension_id
  # after_save :process_after_save

  def process_after_save
  	# QualityLotGaugeResult.skip_callback("save", :after, :process_after_save)
  	pos_tolerance = self.item_part_dimension.item_part_dimension.to_f + self.item_part_dimension.item_part_pos_tolerance.to_f
  	neg_tolerance = self.item_part_dimension.item_part_dimension.to_f - self.item_part_dimension.item_part_neg_tolerance.to_f
  	dimension_max = self.all_lot_gauges.maximum(:lot_gauge_result_value).to_f
  	dimension_min = self.all_lot_gauges.minimum(:lot_gauge_result_value).to_f

  	if dimension_max.between?(neg_tolerance, pos_tolerance) && dimension_min.between?(neg_tolerance, pos_tolerance)
  	  	self.all_lot_gauges.update_all(:lot_gauge_result_status => "accepted")
  	else
  	  	self.all_lot_gauges.update_all(:lot_gauge_result_status => "rejected")
  	end
  	# QualityLotGaugeResult.set_callback("save", :after, :process_after_save)
  end

  def all_lot_gauges
  		self.quality_lot_gauge.quality_lot_gauge_results.where("item_part_dimension_id = ? and lot_gauge_result_appraiser = ?",
  		 self.item_part_dimension_id, self.lot_gauge_result_appraiser).order(:lot_gauge_result_row, :lot_gauge_result_trial)
  end


  def self.process_dimension_results(quality_lot_gauge)
      dimension_results = []
      quality_lot_gauge.quality_lot_gauge_dimensions.each do |gauge_dimension|
          gauge_results = quality_lot_gauge.quality_lot_gauge_results.where(item_part_dimension_id: gauge_dimension.item_part_dimension_id)
          appraisor1_results = QualityLotGaugeResult.process_gauge_results(gauge_results.where(lot_gauge_result_appraiser: 1))
          appraisor2_results = QualityLotGaugeResult.process_gauge_results(gauge_results.where(lot_gauge_result_appraiser: 2))
          appraisor3_results = QualityLotGaugeResult.process_gauge_results(gauge_results.where(lot_gauge_result_appraiser: 3))

          gauge_rbars = [appraisor1_results[:rbar], appraisor2_results[:rbar], appraisor3_results[:rbar]]
          gauge_rbars = gauge_rbars.collect{|p| p.to_f }

          gauge_xbars = [appraisor1_results[:xbar], appraisor2_results[:xbar], appraisor3_results[:xbar]]
          gauge_xbars = gauge_xbars.collect{|p| p.to_f }

          appraisor1_results[:rps] = Array.new(10, 0) unless appraisor1_results[:rps].any?
          appraisor2_results[:rps] = Array.new(10, 0) unless appraisor2_results[:rps].any?
          appraisor3_results[:rps] = Array.new(10, 0) unless appraisor3_results[:rps].any?

          gauge_rp_values = [appraisor1_results[:rps], appraisor2_results[:rps], appraisor3_results[:rps]].transpose.map {|x| x.reduce(:+)}
          gauge_rp_values = gauge_rp_values.collect{|p| (p.to_f/9) }

          gauge_rp = (gauge_rp_values.max.present? && gauge_rp_values.min.present?) ? (gauge_rp_values.max - gauge_rp_values.min) : 0

          gauge_rbar1 = (gauge_rbars.sum / @@gauge_app)

          gauge_rbar2 = (gauge_xbars.max - gauge_xbars.min)

          gauge_uclr = @@gauge_d4 * gauge_rbar1

          gauge_gv = gauge_rbar1 * @@gauge_k1

          gauge_ov = Math.sqrt(((gauge_rbar2 * @@gauge_k2)**2) - ((gauge_gv**2) / (@@gauge_n * @@gauge_trails)))

          gauge_rr = Math.sqrt((gauge_ov**2) + (gauge_gv**2))

          gauge_pv = gauge_rp * @@gauge_k3

          gauge_tv = Math.sqrt((gauge_rr**2) + (gauge_pv**2))
          gauge_rrvp = (gauge_tv == 0) ? 0 : (gauge_rr / gauge_tv * 100)

          pos_tolerance = gauge_dimension.item_part_dimension.item_part_dimension.to_f + gauge_dimension.item_part_dimension.item_part_pos_tolerance.to_f
          neg_tolerance = gauge_dimension.item_part_dimension.item_part_dimension.to_f - gauge_dimension.item_part_dimension.item_part_neg_tolerance.to_f
          gauge_dev = pos_tolerance - neg_tolerance

          gauge_gvp = gauge_gv / gauge_dev * 100
          gauge_ovp = gauge_ov / gauge_dev * 100
          gauge_pvp = gauge_pv / gauge_dev * 100
          gauge_tvp = gauge_tv / gauge_dev * 100
          gauge_rrtp = gauge_rr / gauge_dev * 100

          if gauge_rrtp <= 10
              gauge_status = "Acceped"
          elsif gauge_rrtp.to_f.between?(10, 30)
              gauge_status = "Marginal"
          elsif gauge_rrtp > 30
              gauge_status = "Rejected"
          end
          
          dimension_results << { item_part_letter: gauge_dimension.item_part_dimension.item_part_letter, 
          gv: gauge_gv.round(6).to_s, ov: gauge_ov.round(6).to_s, rr: gauge_rr.round(6).to_s, pv: gauge_pv.round(6).to_s, 
          tv: gauge_tv.round(6).to_s, rrvp: gauge_rrvp.round(2).to_s, rbar1: gauge_rbar1.round(6).to_s, 
          rbar2: gauge_rbar2.round(6).to_s, rp: gauge_rp.round(6).to_s, gvp: gauge_gvp.round(2).to_s, 
          ovp: gauge_ovp.round(2).to_s, pvp: gauge_pvp.round(2).to_s, tvp: gauge_tvp.round(2).to_s, 
          rrtp: gauge_rrtp.round(2).to_s, g_status: gauge_status }
      end
      
      dimension_results
  end


  def self.process_gauge_results(gauge_results)
      row_gauge_results = gauge_results.order(:lot_gauge_result_row,:lot_gauge_result_trial).group(:lot_gauge_result_row)

      row_gauge_trail_sum = row_gauge_results.sum(:lot_gauge_result_value)
      row_gauge_ranges = []
      maximum_results = row_gauge_results.maximum(:lot_gauge_result_value)
      minimum_results = row_gauge_results.minimum(:lot_gauge_result_value)

      maximum_results.each do |key, max_value|
        row_gauge_ranges << max_value - minimum_results[key]
      end

      row_gauge_rbar = (row_gauge_results.length > 0) ? (row_gauge_ranges.sum / row_gauge_results.length) : 0

      column_gauge_results = gauge_results.order(:lot_gauge_result_row,:lot_gauge_result_trial).group(:lot_gauge_result_trial)
      column_gauge_average  = column_gauge_results.average(:lot_gauge_result_value)
      column_gauge_xbar = (column_gauge_average.values.sum / @@gauge_trails)

      {rbar: row_gauge_rbar, xbar: column_gauge_xbar, rps: row_gauge_trail_sum.values}
  end

end
