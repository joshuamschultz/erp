class DepositCheck < ActiveRecord::Base
  belongs_to :payment
  belongs_to :receipt
  has_one :reconcile

   attr_accessible :receipt_id, :status
end
