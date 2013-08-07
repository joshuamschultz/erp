class PoLine < ActiveRecord::Base
  belongs_to :po_header
  belongs_to :organization
  belongs_to :so_line
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :item
  belongs_to :item_revision
  
  attr_accessible :po_line_active, :po_line_cost, :po_line_created_id, :po_line_customer_po, 
  :po_line_notes, :po_line_quantity, :po_line_status, :po_line_total, :po_line_updated_id,
  :po_header_id, :organization_id, :so_line_id, :vendor_quality_id, :customer_quality_id,
  :item_id, :item_revision_id

end
