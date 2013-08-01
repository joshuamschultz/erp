class ItemPrint < ActiveRecord::Base
  belongs_to :item
  belongs_to :print
  attr_accessible :item_id, :print_id
end
