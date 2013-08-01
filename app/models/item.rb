class Item < ActiveRecord::Base
  attr_accessible :owner_id, :organization_id, :item_active, :item_cost, :item_created_id, 
  :item_description, :item_name, :item_notes, :item_part_no, :item_quantity_in_hand, 
  :item_quantity_on_order, :item_revision, :item_revision_date, :item_tooling, :item_updated_id

  validates_presence_of :owner
  validates_presence_of :organization

  belongs_to :owner
  belongs_to :organization

  has_many :item_prints
  has_many :item_materials
  has_many :item_processes
  has_many :item_specifications
  has_many :item_alt_names
  has_many :item_part_dimensions  
end
