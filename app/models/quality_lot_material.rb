class QualityLotMaterial < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :material_element

  attr_accessible :lot_material_active, :lot_material_created_id, :lot_material_notes, 
  :lot_material_result, :lot_material_tested, :lot_material_updated_id, :quality_lot_id,
  :material_element_id, :lot_element_low_range, :lot_element_high_range

  validates :quality_lot_id, :uniqueness => { :scope => :material_element_id, :message => "have test for the element already!" }

  validates_presence_of :lot_element_low_range #, :lot_element_high_range

  validates_numericality_of :lot_element_low_range #, :lot_element_high_range

  before_save :process_before_save

  def process_before_save
		low_range = self.material_element.element_low_range.to_f
		high_range = self.material_element.element_high_range.to_f

		if (self.lot_element_low_range.to_f).between?(low_range, high_range) #&& (self.lot_element_high_range.to_f).between?(low_range, high_range)
			self.lot_material_result = "accepted"
		else
			self.lot_material_result = "rejected"
		end
  end


end
