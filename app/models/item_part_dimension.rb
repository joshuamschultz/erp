class ItemPartDimension < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :dimension

  after_initialize :default_values

  def default_values
	   self.item_part_active = true if self.item_part_active.nil?
  end

  attr_accessible :item_revision_id, :dimension_id, :item_part_active, :item_part_created_id, :item_part_critical, 
  :item_part_letter, :item_part_neg_tolerance, :item_part_notes, :item_part_pos_tolerance, 
  :item_part_dimension, :item_part_updated_id

  validates_presence_of :item_revision
  validates_presence_of :dimension
end
