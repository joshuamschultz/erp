class CreditRegister < ActiveRecord::Base
  attr_accessible :amount, :balance, :organization_id, :payment_id, :rec, :transaction_date

  belongs_to :payment

  def self.calculate_balance
  	@credit_registers = CreditRegister.all
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
