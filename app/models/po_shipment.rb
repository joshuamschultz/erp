class PoShipment < ActiveRecord::Base
  belongs_to :po_line
  attr_accessible :po_shipment_active, :po_shipment_created_id, :po_shipment_updated_id, :shipped_item_count, :shipped_item_description, :shipped_item_identifier
end
