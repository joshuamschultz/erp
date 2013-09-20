class PaymentLine < ActiveRecord::Base
  belongs_to :payment
  belongs_to :payable
  attr_accessible :payment_line_amount, :payment_line_created_id, :payment_line_updated_id, 
  :payment_id, :payable_id

  validates_presence_of :payment_line_amount, :payable_id

end
