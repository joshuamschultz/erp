class ItemSpecification < ActiveRecord::Base
  belongs_to :item
  belongs_to :specification
  attr_accessible :item_id, :specification_id
end
