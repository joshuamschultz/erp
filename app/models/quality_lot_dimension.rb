class QualityLotDimension < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :item_part_dimension

  attr_accessible :lot_dimension_active, :lot_dimension_created_id, :lot_dimension_notes, 
  :lot_dimension_status, :lot_dimension_updated_id, :quality_lot_id, :item_part_dimension_id,
  :lot_dimension_value

  validates_presence_of :quality_lot, :item_part_dimension_id, :lot_dimension_value

  after_save :process_after_save

  def process_after_save
  		QualityLotDimension.skip_callback("save", :after, :process_after_save)
  		self.all_lot_dimensions.update_all(:lot_dimension_status => self.lot_dimension_status)
  		QualityLotDimension.set_callback("save", :after, :process_after_save)
  end

  def all_lot_dimensions
  		self.quality_lot.quality_lot_dimensions.where(:item_part_dimension_id => self.item_part_dimension_id)
  end

  # validates :quality_lot_id, :uniqueness => { :scope => :item_part_dimension_id, :message => "have test for the part dimension already!" }
end
