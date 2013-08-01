class ItemMaterial < ActiveRecord::Base
  belongs_to :item
  belongs_to :material
  attr_accessible :item_id, :material_id
end
