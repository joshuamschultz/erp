class Reconcile < ActiveRecord::Base
  belongs_to :payment
  belongs_to :receipt
  belongs_to :deposit_check
  belongs_to :printing_screen
  attr_accessible :tag, :reconcile_type, :payment_id, :deposit_check_id, :printing_screen_id, :receipt_id

  scope :type_based_reconcile, lambda{|type| where(:reconcile_type => type, :tag => "not reconciled") }
end
