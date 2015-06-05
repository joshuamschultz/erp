class ItemRevisionItemPartDimension < ActiveRecord::Base
  attr_accessible :item_part_dimension_id, :item_revision_id

  belongs_to :item_revision
  belongs_to :item_part_dimension
end
