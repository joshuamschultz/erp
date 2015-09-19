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
