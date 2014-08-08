class ItemPartDimension < ActiveRecord::Base
	belongs_to :item_revision
	belongs_to :dimension
	belongs_to :gauge

	after_initialize :default_values
	before_save :before_save_process


	attr_accessible :item_revision_id, :dimension_id, :item_part_active, :item_part_created_id, :item_part_critical,
		:item_part_letter, :item_part_neg_tolerance, :item_part_notes, :item_part_pos_tolerance,
		:item_part_dimension, :item_part_updated_id, :gauge_id, :go_non_go, :dimension_string


	def before_save_process
		unless self.go_non_go
			self.item_part_dimension = self.dimension_string.to_f
		end
	end

	def default_values
		self.item_part_active = true if self.item_part_active.nil?
	end

 	validate :check_dimension	

 	def check_dimension
 		if self.go_non_go == false
 			if (self.dimension_string.to_f.is_a? Float)
 			 	if self.dimension_string.to_f == 0.0
 					errors.add(:dimension_string, " Must be a float value")
 				end
 			else
 				errors.add(:dimension_string, " Must be a float value")
 			end
 		end
 		if self.go_non_go == true && self.item_part_critical == true
 			errors.add(:go_non_go, "Choose any one Critical or Go/Nogo")
 			errors.add(:item_part_critical, "Choose any one Critical or Go/Nogo")
 		end
 	end

	validates_presence_of :item_revision
	validates_presence_of :dimension
	validates_presence_of :gauge

	has_many :quality_lot_dimensions, :dependent => :destroy
	has_many :quality_lot_capabilities, :dependent => :destroy
	has_many :quality_lot_gauge_dimensions, :dependent => :destroy
	has_many :quality_lot_gauge_results, :dependent => :destroy
end
