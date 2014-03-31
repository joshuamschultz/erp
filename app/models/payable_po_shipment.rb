class PayablePoShipment < ActiveRecord::Base
  belongs_to :po_shipment
  belongs_to :payable
  attr_accessible :po_shipment_id, :payable_id

  after_destroy :process_after_destroy

  def process_after_destroy
  		self.payable.process_payable_total if self.payable
  end

end
