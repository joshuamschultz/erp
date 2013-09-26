class QualityLotGaugeResult < ActiveRecord::Base
  belongs_to :quality_lot_gauge
  attr_accessible :lot_gauge_result_appraiser, :lot_gauge_result_value
end
