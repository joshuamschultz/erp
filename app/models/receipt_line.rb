class ReceiptLine < ActiveRecord::Base
  belongs_to :receipt
  attr_accessible :receipt_line_amount, :receipt_line_created_id, 
  :receipt_line_updated_id, :receipt_id
end
