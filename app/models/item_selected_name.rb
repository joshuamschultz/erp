class ItemSelectedName < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :item_alt_name

  attr_accessible :item_revision_id, :item_alt_name_id
end
