# == Schema Information
#
# Table name: quality_lot_capabilities
#
#  id                       :integer          not null, primary key
#  quality_lot_id           :integer
#  item_part_dimension_id   :integer
#  lot_dimension_value      :decimal(25, 10)  default(0.0)
#  lot_dimension_status     :string(255)
#  lot_dimension_notes      :text(65535)
#  lot_dimension_active     :boolean
#  lot_dimension_created_id :integer
#  lot_dimension_updated_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class QualityLotCapability < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :item_part_dimension

  attr_accessible :lot_dimension_active, :lot_dimension_created_id, :lot_dimension_notes,
  :lot_dimension_status, :lot_dimension_updated_id, :quality_lot_id, :item_part_dimension_id,
  :lot_dimension_value

  validates_presence_of :quality_lot, :item_part_dimension_id

  after_save :process_after_save

  def process_after_save
    QualityLotCapability.skip_callback("save", :after, :process_after_save, raise: false)

    pos_tolerance = self.item_part_dimension.item_part_dimension.to_f + self.item_part_dimension.item_part_pos_tolerance.to_f
    neg_tolerance = self.item_part_dimension.item_part_dimension.to_f - self.item_part_dimension.item_part_neg_tolerance.to_f
    dimension_max = self.all_lot_capabilities.maximum(:lot_dimension_value).to_f
    dimension_min = self.all_lot_capabilities.minimum(:lot_dimension_value).to_f

    if dimension_max.between?(neg_tolerance, pos_tolerance) && dimension_min.between?(neg_tolerance, pos_tolerance)
       self.all_lot_capabilities.update_all(:lot_dimension_status => "accepted")
    else
       self.all_lot_capabilities.update_all(:lot_dimension_status => "rejected")
    end

    QualityLotCapability.set_callback("save", :after, :process_after_save)
  end

  def all_lot_capabilities
      self.quality_lot.quality_lot_capabilities.where(:item_part_dimension_id => self.item_part_dimension_id)
  end

  # validates :quality_lot_id, :uniqueness => { :scope => :item_part_dimension_id, :message => "have test for the part dimension already!" }
end
