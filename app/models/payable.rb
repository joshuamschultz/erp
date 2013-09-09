class Payable < ActiveRecord::Base
  belongs_to :organization
  belongs_to :po_header
  attr_accessible :payable_active, :payable_cost, :payable_created_id, :payable_description, :payable_discount, :payable_due_date, :payable_identifier, :payable_invoice_date, :payable_notes, :payable_status, :payable_to_id, :payable_total, :payable_updated_id
end
