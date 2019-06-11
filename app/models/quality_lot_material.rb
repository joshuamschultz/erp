# == Schema Information
#
# Table name: quality_lot_materials
#
#  id                      :integer          not null, primary key
#  quality_lot_id          :integer
#  material_element_id     :integer
#  lot_element_low_range   :decimal(25, 10)  default(0.0)
#  lot_element_high_range  :decimal(25, 10)  default(0.0)
#  lot_material_tested     :boolean
#  lot_material_result     :string(255)
#  lot_material_notes      :text(65535)
#  lot_material_active     :boolean
#  lot_material_created_id :integer
#  lot_material_updated_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class QualityLotMaterial < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :material_element

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
