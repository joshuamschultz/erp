class QualityLotDimension < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :item_part_dimension

  attr_accessible :lot_dimension_active, :lot_dimension_avg, :lot_dimension_created_id, 
  :lot_dimension_max, :lot_dimension_min, :lot_dimension_notes, :lot_dimension_status, 
  :lot_dimension_std, :lot_dimension_updated_id, :quality_lot_id, :item_part_dimension_id

  validates_presence_of :quality_lot, :item_part_dimension_id, :lot_dimension_avg, :lot_dimension_max, 
  :lot_dimension_min, :lot_dimension_status, :lot_dimension_std

  validates :quality_lot_id, :uniqueness => { :scope => :item_part_dimension_id, :message => "have test for the part dimension already!" }
end
