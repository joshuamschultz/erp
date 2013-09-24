class PayableShipment < ActiveRecord::Base
  belongs_to :payable
  belongs_to :po_line

  attr_accessible :payable_shipment_cost, :payable_shipment_count, :payable_shipment_created_id, 
  :payable_shipment_identifier, :payable_shipment_updated_id, :payable_id, :po_line_id

  before_save :process_before_save

  def process_before_save
		  self.payable_shipment_cost = self.payable_shipment_count * self.po_line.po_line_cost
  end

  after_destroy :process_after_destroy

  def process_after_destroy
  		self.payable.process_payable_total
  end

  validate :check_total_received, :on => :update

  def check_total_received
  		total_received = self.po_line.payable_shipments.sum(:payable_shipment_count) + self.payable_shipment_count
  		if total_received > self.po_line.po_line_quantity
  			errors.add(:payable_shipment_count, "exceeded than ordered!")
  		end
  end

end
