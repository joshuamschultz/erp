# == Schema Information
#
# Table name: check_entries
#
#  id               :integer          not null, primary key
#  check_identifier :string(255)
#  check_code       :string(255)
#  check_active     :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  status           :string(255)
#

class CheckEntry < ActiveRecord::Base

  has_one :payment
  #, :class_name => "Payment", :foreign_key => "payment_check_code", :primary_key => 'check_code'
  # has_one :receipt, :class_name => "Receipt", :foreign_key => "receipt_check_code", :primary_key => 'check_code'

  # validates_presence_of :check_code
  # validates  :check_code,
  #            :uniqueness => { :allow_blank => true }

  def self.get_next_check_code
    last_check = CheckEntry.order(:id).last
    if last_check && last_check.payment.nil?
        last_check.check_code
    elsif last_check
        last_check.check_code.next
    else
        ""
    end
  end

  def check_belongs_to
		if self.payment
			{type: "Payment", name: self.payment.payment_identifier, object: self.payment}
		# elsif self.receipt
		# 	{type: "Receipt", name: self.receipt.receipt_identifier, object: self.receipt}
		end
  end

end
