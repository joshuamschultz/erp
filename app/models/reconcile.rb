# == Schema Information
#
# Table name: reconciles
#
#  id                 :integer          not null, primary key
#  reconcile_type     :string(255)
#  payment_id         :integer
#  tag                :string(255)
#  deposit_check_id   :integer
#  printing_screen_id :integer
#  reconcile_status   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  receipt_id         :integer
#

class Reconcile < ActiveRecord::Base
  belongs_to :payment
  belongs_to :receipt
  belongs_to :deposit_check
  belongs_to :printing_screen
  

  scope :type_based_reconcile, lambda{|type| where(:reconcile_type => type, :tag => "not reconciled") }
end
