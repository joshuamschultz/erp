class ItemSelectedName < ActiveRecord::Base
  belongs_to :item
  belongs_to :item_alt_name

  attr_accessible :item_id, :item_alt_name_id
end
