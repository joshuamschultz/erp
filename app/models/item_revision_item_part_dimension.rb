# == Schema Information
#
# Table name: item_revision_item_part_dimensions
#
#  id                     :integer          not null, primary key
#  item_revision_id       :integer
#  item_part_dimension_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class ItemRevisionItemPartDimension < ActiveRecord::Base
  attr_accessor :item_part_dimension_id, :item_revision_id

  belongs_to :item_revision
  belongs_to :item_part_dimension
end
