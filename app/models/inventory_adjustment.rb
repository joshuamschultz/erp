class InventoryAdjustment < ActiveRecord::Base
  attr_accessible :inventory_adjustment_description, :inventory_adjustment_quantity, :item_alt_name_id, :item_id, :quality_lot_id


  belongs_to :item
  belongs_to :item_alt_name
  belongs_to :quality_lot


  after_save :before_create_process
  def before_create_process
    self.item_id = item_no

    @quality_lot = QualityLot.find(self.quality_lot_id)
    @quality_lot.update_attribute(:lot_quantity , self.inventory_adjustment_quantity)

  end
  def item_no
  	self.item_alt_name.item.id
  end


end
