class InventoryAdjustment < ActiveRecord::Base
  attr_accessible :inventory_adjustment_description, :inventory_adjustment_quantity, :item_alt_name_id, :item_id, :quality_lot_id


  belongs_to :item
  belongs_to :item_alt_name
  belongs_to :quality_lot


  after_save :after_create_process
  before_create :before_create_process

  before_validation :validate_on_create_update 

protected
  def validate_on_create_update
    if (self.inventory_adjustment_quantity + self.quality_lot.lot_quantity) < 0
        self.errors.add(:inventory_adjustment_quantity, "Adjustment quantity more than lot_quantity") 
    end
  end

  def after_create_process
    @quality_lot = QualityLot.find(self.quality_lot_id)
    @lot_quantity =@quality_lot.lot_quantity + self.inventory_adjustment_quantity
    @quantity_on_hand =@quality_lot.quantity_on_hand + self.inventory_adjustment_quantity
    @quality_lot.update_attribute(:lot_quantity , @lot_quantity)
    final_date = Time.now
    lot_status = "open"
    finished = false
    if @quantity_on_hand == 0
      final_date = Time.now
      lot_status = "closed"
      finished = true
    end

    @quality_lot.update_attributes(quantity_on_hand: @quantity_on_hand, lot_status: lot_status, final_date: final_date,finished: finished)
  end
  def before_create_process 
    self.item_id = item_no
  end
  def item_no
  	self.item_alt_name.item.id
  end


end
