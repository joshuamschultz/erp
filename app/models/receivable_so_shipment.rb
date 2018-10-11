# == Schema Information
#
# Table name: receivable_so_shipments
#
#  id             :integer          not null, primary key
#  so_shipment_id :integer
#  receivable_id  :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class ReceivableSoShipment < ActiveRecord::Base
  belongs_to :so_shipment
  belongs_to :receivable
  attr_accessor :so_shipment_id, :receivable_id

  after_destroy :process_after_destroy

  def process_after_destroy
  		self.receivable.process_receivable_total if self.receivable
  end
end
