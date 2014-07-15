class QualityLotDimension < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :item_part_dimension

  attr_accessible :lot_dimension_active, :lot_dimension_created_id, :lot_dimension_notes, 
  :lot_dimension_status, :lot_dimension_updated_id, :quality_lot_id, :item_part_dimension_id,
  :lot_dimension_value

  validates_presence_of :quality_lot, :item_part_dimension_id

  after_save :process_after_save

  def process_after_save
    if self.item_part_dimension.go_non_go
      QualityLotDimension.skip_callback("save", :after, :process_after_save)
      p  self.lot_dimension_value.to_i
      if self.lot_dimension_value.to_i == 1
        result = self.quality_lot.quality_lot_dimensions.where(:item_part_dimension_id => self.item_part_dimension_id).collect(&:lot_dimension_value)
        result = result.map(&:to_i)
        result = result.uniq
        if result.size == 1 && result[0] == 1
          self.all_lot_dimensions.update_all(:lot_dimension_status => "accepted")
        else
          self.all_lot_dimensions.update_all(:lot_dimension_status => "rejected")
        end
      else
        self.all_lot_dimensions.update_all(:lot_dimension_status => "rejected")
      end
      QualityLotDimension.set_callback("save", :after, :process_after_save)
    else
      QualityLotDimension.skip_callback("save", :after, :process_after_save)

      pos_tolerance = self.item_part_dimension.item_part_dimension.to_f + self.item_part_dimension.item_part_pos_tolerance.to_f
      neg_tolerance = self.item_part_dimension.item_part_dimension.to_f - self.item_part_dimension.item_part_neg_tolerance.to_f
      dimension_max = self.all_lot_dimensions.maximum(:lot_dimension_value).to_f
      dimension_min = self.all_lot_dimensions.minimum(:lot_dimension_value).to_f

      if dimension_max.between?(neg_tolerance, pos_tolerance) && dimension_min.between?(neg_tolerance, pos_tolerance)
          self.all_lot_dimensions.update_all(:lot_dimension_status => "accepted")
      else
          self.all_lot_dimensions.update_all(:lot_dimension_status => "rejected")
      end

      QualityLotDimension.set_callback("save", :after, :process_after_save)
    end
  end

  def all_lot_dimensions
      self.quality_lot.quality_lot_dimensions.where(:item_part_dimension_id => self.item_part_dimension_id)
  end

  # validates :quality_lot_id, :uniqueness => { :scope => :item_part_dimension_id, :message => "have test for the part dimension already!" }

end
