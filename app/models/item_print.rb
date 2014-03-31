class ItemPrint < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :print
  attr_accessible :item_revision_id, :print_id
end
