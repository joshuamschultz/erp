class CheckRegister < ActiveRecord::Base

  attr_accessible :amount, :balance, :check_code, :deposit, :organization_id, :rec, :transaction_date, :payment_id, :receipt_id
  
  belongs_to :payment 
  belongs_to :receipt  
  
end
