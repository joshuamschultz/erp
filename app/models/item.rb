class Item < ActiveRecord::Base
  belongs_to :owner
  attr_accessible :owner_id, :item_active, :item_cost, :item_created_id, :item_description, :item_name, :item_notes, :item_part_no, :item_quantity_in_hand, :item_quantity_on_order, :item_revision, :item_revision_date, :item_tooling, :item_updated_id
end
