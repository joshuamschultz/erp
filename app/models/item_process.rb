# == Schema Information
#
# Table name: item_processes
#
#  id               :integer          not null, primary key
#  item_revision_id :integer
#  process_type_id  :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ItemProcess < ActiveRecord::Base
  belongs_to :item_revision
  belongs_to :process_type

end
