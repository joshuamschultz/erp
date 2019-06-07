# == Schema Information
#
# Table name: item_lots
#
#  id             :integer          not null, primary key
#  quality_lot_id :integer
#  item_id        :integer
#  item_lot_count :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class ItemLot < ActiveRecord::Base

  belongs_to :item
  belongs_to :quality_lot

  validates_presence_of :item_id

  #validates :item_lot_count, presence: true, uniqueness: {scope: :item_id}


  ################## NO NEED! CHECK LATER ###################

  # before_create :before_create_process
  # def before_create_process
  #   item_lot = ItemLot.where(:item_id => self.item_id)
  #   if item_lot.last.present?
  #     if item_lot.last.item_lot_count == self.item_lot_count 

  #       self.item_lot_count += 1
  #     end
  #   end
  # end

end
