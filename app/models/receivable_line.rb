class ReceivableLine < ActiveRecord::Base
  belongs_to :receivable
  attr_accessible :receivable_line_active, :receivable_line_cost, :receivable_line_created_id, :receivable_line_description, :receivable_line_identifier, :receivable_line_notes, :receivable_line_status, :receivable_line_updated_id
end
