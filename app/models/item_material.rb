# == Schema Information
#
# Table name: item_materials
#
#  id               :integer          not null, primary key
#  item_revision_id :integer
#  material_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ItemMaterial < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :material
  attr_accessor :item_revision_id, :material_id
end
