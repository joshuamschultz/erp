class ItemPartDimension < ActiveRecord::Base
  belongs_to :item
  attr_accessible :item_id, :item_part_active, :item_part_created_id, :item_part_critical, :item_part_letter, :item_part_neg_tolerance, :item_part_notes, :item_part_pos_tolerance, :item_part_type, :item_part_updated_id
  validates_presence_of :item
end
