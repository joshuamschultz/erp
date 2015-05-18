class ItemLot < ActiveRecord::Base
  attr_accessible :item_id, :item_lot_count, :quality_lot_id

  belongs_to :item
  
  belongs_to :quality_lot

  validates :item_lot_count, uniqueness: {scope: :item_id}

  validates_presence_of :item_id

  before_create :before_create_process

  def before_create_process
  	p "====================="

  	p  self.item_lot_count
  	p "=================="
	item_lot = ItemLot.where(:item_id => self.item_id)
	if item_lot.last.present?
		if item_lot.last.item_lot_count == self.item_lot_count 

			self.item_lot_count += 1
		end
	end
  end
  		
end
