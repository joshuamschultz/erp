class QualityLotMaterial < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :material_element
  attr_accessible :lot_material_active, :lot_material_created_id, :lot_material_notes, :lot_material_result, :lot_material_tested, :lot_material_updated_id
end
