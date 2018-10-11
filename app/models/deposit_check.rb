# == Schema Information
#
# Table name: deposit_checks
#
#  id               :integer          not null, primary key
#  status           :string(255)
#  payment_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#  receipt_id       :integer
#  receipt_type     :string(255)
#  check_identifier :string(255)
#  active           :integer
#

class DepositCheck < ActiveRecord::Base
  include Rails.application.routes.url_helpers 
  belongs_to :payment
  belongs_to :receipt
  has_one :reconcile

   attr_accessor :receipt_id, :status, :check_identifier, :receipt_type, :active


  def get_receivables
      @identifiers = Array.new
      if self.receipt
      receivable_ids = self.receipt.receipt_lines.collect(&:receivable_id)
      receivable_ids.each do |p|
        receivable = Receivable.find (p)
        @identifiers.push(CommonActions.linkable(receivable_path(receivable), receivable.receivable_identifier))
      end 
    end  
    @identifiers
  end 
end
