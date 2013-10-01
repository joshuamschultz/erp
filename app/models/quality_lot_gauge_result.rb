class QualityLotGaugeResult < ActiveRecord::Base
  belongs_to :quality_lot_gauge
  belongs_to :item_part_dimension

  attr_accessible :lot_gauge_result_appraiser, :lot_gauge_result_value, :quality_lot_gauge_id, 
  :item_part_dimension_id, :lot_gauge_result_status

  # validates_presence_of :item_part_dimension_id

  # after_save :process_after_save

  def process_after_save
  	# QualityLotGaugeResult.skip_callback("save", :after, :process_after_save)
	pos_tolerance = self.item_part_dimension.item_part_dimension + self.item_part_dimension.item_part_pos_tolerance
	neg_tolerance = self.item_part_dimension.item_part_dimension - self.item_part_dimension.item_part_neg_tolerance
	dimension_max = self.all_lot_gauges.maximum(:lot_gauge_result_value)
	dimension_min = self.all_lot_gauges.minimum(:lot_gauge_result_value)

	if dimension_max.between?(neg_tolerance, pos_tolerance) && dimension_min.between?(neg_tolerance, pos_tolerance)
	  	self.all_lot_gauges.update_all(:lot_gauge_result_status => "accepted")
	else
	  	self.all_lot_gauges.update_all(:lot_gauge_result_status => "rejected")
	end

	# QualityLotGaugeResult.set_callback("save", :after, :process_after_save)
  end

  def all_lot_gauges
  		self.quality_lot_gauge.quality_lot_gauge_results.where("item_part_dimension_id = ? and lot_gauge_result_appraiser = ?",
  		 self.item_part_dimension_id, self.lot_gauge_result_appraiser)
  end

end
