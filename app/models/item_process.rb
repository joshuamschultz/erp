class ItemProcess < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :process_type
  attr_accessible :item_revision_id, :process_type_id
end
