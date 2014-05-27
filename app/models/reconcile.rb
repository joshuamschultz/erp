class Reconcile < ActiveRecord::Base
  belongs_to :payment
  belongs_to :deposit_check
  belongs_to :printing_screen
  attr_accessible :reconcile_status, :reconcile_type, :tag
end
