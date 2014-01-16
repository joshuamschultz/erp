class PayableAccount < ActiveRecord::Base
  belongs_to :payable
  belongs_to :gl_account
  
  attr_accessible :payable_id, :gl_account_id, :payable_account_amount, :payable_account_created_id, 
  :payable_account_description, :payable_account_updated_id

  validates_presence_of :payable, :gl_account, :payable_account_amount

  validates_numericality_of :payable_account_amount, greater_than: 0

end
