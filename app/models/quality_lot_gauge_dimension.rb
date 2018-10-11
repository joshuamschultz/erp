# == Schema Information
#
# Table name: quality_lot_gauge_dimensions
#
#  id                         :integer          not null, primary key
#  quality_lot_gauge_id       :integer
#  item_part_dimension_id     :integer
#  lot_gauge_dimension_active :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#

class QualityLotGaugeDimension < ActiveRecord::Base
  belongs_to :quality_lot_gauge
  belongs_to :item_part_dimension

  attr_accessor :lot_gauge_dimension_active, :quality_lot_gauge_id, :item_part_dimension_id
end
