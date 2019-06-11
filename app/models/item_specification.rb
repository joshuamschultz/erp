# == Schema Information
#
# Table name: item_specifications
#
#  id               :integer          not null, primary key
#  item_revision_id :integer
#  specification_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ItemSpecification < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :specification
end
