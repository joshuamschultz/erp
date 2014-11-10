class CheckRegister < ActiveRecord::Base

  attr_accessible :amount, :balance, :check_code, :deposit, :organization_id, :rec, :transaction_date, :payment_id, :receipt_id
  
  belongs_to :payment 
  belongs_to :receipt  

  def self.calculate_balance
  	@check_registers = CheckRegister.all
  	total_amount = 0
  	if @check_registers.any?
	  	@check_registers.each do |c|
	  		if c.amount
	  			total_amount += c.amount
	  	    elsif c.deposit
	  	    	total_amount += c.deposit
	  	    end 		
	  	end	  	
	  	total_amount 
	end 	
  end

end
