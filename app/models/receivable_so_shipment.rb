class ReceivableSoShipment < ActiveRecord::Base
  belongs_to :so_shipment
  belongs_to :receivable
  attr_accessible :so_shipment_id, :receivable_id

  after_destroy :process_after_destroy

  def process_after_destroy
  		self.receivable.process_receivable_total if self.receivable
  end
end
