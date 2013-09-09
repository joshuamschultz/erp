class QualityLotMaterial < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :material_element

  attr_accessible :lot_material_active, :lot_material_created_id, :lot_material_notes, 
  :lot_material_result, :lot_material_tested, :lot_material_updated_id, :quality_lot_id,
  :material_element_id, :lot_element_low_range, :lot_element_high_range

  validates_presence_of :quality_lot, :material_element, :material_element_id

  validates :quality_lot_id, :uniqueness => { :scope => :material_element_id, :message => "have test for the element already!" }
end
