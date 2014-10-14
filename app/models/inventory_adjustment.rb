class InventoryAdjustment < ActiveRecord::Base
  attr_accessible :inventory_adjustment_description, :inventory_adjustment_quantity, :item_alt_name_id, :item_id, :quality_lot_id


  belongs_to :item
  belongs_to :item_alt_name
  belongs_to :quality_lot


  before_save :update_item
  after_save :update_item
  def update_item
    self.item_id = item_no
  end
  def item_no
  	self.item_alt_name.item.id
  end


end
