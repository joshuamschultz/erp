class QualityLotGaugeDimension < ActiveRecord::Base
  belongs_to :quality_lot_gauge
  belongs_to :item_part_dimension
  attr_accessible :lot_gauge_dimension_active
end
