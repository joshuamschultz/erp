class ItemAltName < ActiveRecord::Base
  belongs_to :item
  attr_accessible :item_alt_active, :item_alt_created_id, :item_alt_description, :item_alt_identifier, :item_alt_notes, :item_alt_updated_id
end
