require 'faker' 
FactoryGirl.define do
  factory :payable do |f| 
		f.organization_id 8
		f.payable_invoice "test"
		f.payable_invoice_date {Faker::Business.credit_card_expiry_date}
		f.payable_due_date {Faker::Business.credit_card_expiry_date}
		f.payable_cost 10    
  end

end
