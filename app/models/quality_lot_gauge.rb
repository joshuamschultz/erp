class QualityLotGauge < ActiveRecord::Base
  has_many :quality_lot_gauge_results
  has_many :quality_lot_gauge_dimensions
  belongs_to :quality_lot
  attr_accessible :lot_gauge_active, :lot_gauge_created_id, :lot_gauge_notes, :lot_gauge_status, :lot_gauge_updated_id
end
