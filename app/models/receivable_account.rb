class ReceivableAccount < ActiveRecord::Base
  belongs_to :receivable
  belongs_to :gl_account

  attr_accessible :receivable_id, :gl_account_id, :receivable_account_amount, :receivable_account_created_id, 
  :receivable_account_description, :receivable_account_updated_id

  validates_presence_of :receivable, :gl_account, :receivable_account_amount

  validates_numericality_of :receivable_account_amount, greater_than: 0
end
