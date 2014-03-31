class ItemMaterial < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :material
  attr_accessible :item_revision_id, :material_id
end
