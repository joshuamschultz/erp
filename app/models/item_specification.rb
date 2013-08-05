class ItemSpecification < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :specification
  attr_accessible :item_revision_id, :specification_id
end
