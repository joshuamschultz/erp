# == Schema Information
#
# Table name: item_prints
#
#  id               :integer          not null, primary key
#  item_revision_id :integer
#  print_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ItemPrint < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :print
  attr_accessible :item_revision_id, :print_id
end
