class Receipt < ActiveRecord::Base
  has_many :receipt_lines
  belongs_to :organization
  attr_accessible :receipt_active, :receipt_check_amount, :receipt_check_code, :receipt_check_no, :receipt_created_id, :receipt_description, :receipt_identifier, :receipt_notes, :receipt_status, :receipt_type_id, :receipt_updated_id
end
