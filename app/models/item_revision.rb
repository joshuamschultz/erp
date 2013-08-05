class ItemRevision < ActiveRecord::Base
  belongs_to :item
  belongs_to :owner
  belongs_to :organization
  belongs_to :vendor_quality
  belongs_to :customer_quality
  
  attr_accessible :item_cost, :item_description, :item_name, :item_notes, :item_revision_created_id, 
  :item_revision_date, :item_revision_name, :item_revision_updated_id, :item_tooling
end
