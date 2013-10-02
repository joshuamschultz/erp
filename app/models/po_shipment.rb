class PoShipment < ActiveRecord::Base
  belongs_to :po_line
  
  attr_accessible :po_line_id, :po_shipment_created_id, :po_shipment_updated_id, 
  :po_shipped_count, :po_shipped_cost, :po_shipped_shelf, :po_shipped_unit
end
