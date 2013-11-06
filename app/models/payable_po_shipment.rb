class PayablePoShipment < ActiveRecord::Base
  belongs_to :po_shipment
  belongs_to :payable
  attr_accessible :po_shipment_id, :payable_id
end
