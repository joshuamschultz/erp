class CheckEntry < ActiveRecord::Base
  include Rails.application.routes.url_helpers 

  attr_accessible :check_active, :check_code, :check_identifier

  validates_presence_of :check_code

  validates_uniqueness_of :check_code

  def self.get_next_check_code
      Payment.joins(:check_entry)
  		next_check = CheckEntry.where("id not in (?)", [0] + Payment.joins(:check_entry).collect(&:check_entry_id) + 
        Receipt.joins(:check_entry).collect(&:check_entry_id)).order(:id).first

  		if next_check
  			 next_check.check_code
  		else
          last_check = CheckEntry.order(:id).last
    			if last_check
    				  last_check.check_code.next
    			else
    				  ""
    			end
  		end
  end

  def check_belongs_to
  		if self.payment
  			{type: "Payment", name: self.payment.payment_identifier, object: self.payment}
  		elsif self.receipt
  			{type: "Receipt", name: self.receipt.receipt_identifier, object: self.receipt}
  		end
  end

  has_one :payment 
  
  #, :class_name => "Payment", :foreign_key => "payment_check_code", :primary_key => 'check_code'
  # has_one :receipt, :class_name => "Receipt", :foreign_key => "receipt_check_code", :primary_key => 'check_code'
end