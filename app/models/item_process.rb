class ItemProcess < ActiveRecord::Base
  belongs_to :item
  belongs_to :process_type
  attr_accessible :item_id, :process_type_id
end
