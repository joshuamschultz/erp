class SoShipment < ActiveRecord::Base
  belongs_to :so_line

  attr_accessible :so_line_id, :so_shipment_updated_id, :so_shipment_created_id, 
  :so_shipped_cost, :so_shipped_count, :so_shipped_shelf, :so_shipped_unit
end
