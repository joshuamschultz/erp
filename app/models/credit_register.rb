# == Schema Information
#
# Table name: credit_registers
#
#  id               :integer          not null, primary key
#  transaction_date :date
#  payment_id       :integer
#  organization_id  :integer
#  amount           :decimal(10, )
#  balance          :decimal(10, )
#  rec              :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  receipt_id       :integer
#

class CreditRegister < ActiveRecord::Base
  attr_accessible :amount, :balance, :organization_id, :payment_id, :rec, :transaction_date, :receipt_id

  belongs_to :payment
  belongs_to :receipt

  def self.calculate_balance(mode_type)
  	@credit_registers = mode_type == 'receipt' ? CreditRegister.includes(:receipt) : CreditRegister.includes(:payment)
  	total_amount = 0
  	if @credit_registers.any?
	  	@credit_registers.each do |c|
	  		if c.amount
	  			total_amount -= c.amount	  	    
	  	    end 		
	  	end	  	
	  	total_amount 
	end 	
  end

end
