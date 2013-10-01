class QualityLotMaterial < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :material_element

  attr_accessible :lot_material_active, :lot_material_created_id, :lot_material_notes, 
  :lot_material_result, :lot_material_tested, :lot_material_updated_id, :quality_lot_id,
  :material_element_id, :lot_element_low_range, :lot_element_high_range

  validates :quality_lot_id, :uniqueness => { :scope => :material_element_id, :message => "have test for the element already!" }

  before_save :process_before_save

  def process_before_save
  		puts "hi"
		
		low_range = self.material_element.element_low_range
		high_range = self.material_element.element_high_range

		puts low_range
		puts high_range

		puts self.lot_element_low_range
		puts self.lot_element_high_range

		puts (low_range..high_range).include?(self.lot_element_low_range)

		puts (low_range..high_range).include?(self.lot_element_high_range)

		if (low_range..high_range).include?(self.lot_element_low_range) && (low_range..high_range).include?(self.lot_element_high_range)
			self.lot_material_result = "accepted"
		else
			self.lot_material_result = "rejected"
		end
  end


end
