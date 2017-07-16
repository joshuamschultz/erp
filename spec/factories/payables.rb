# == Schema Information
#
# Table name: payables
#
#  id                   :integer          not null, primary key
#  organization_id      :integer
#  po_header_id         :integer
#  payable_to_id        :integer
#  payable_identifier   :string(255)
#  payable_description  :string(255)
#  payable_cost         :decimal(25, 10)  default(0.0)
#  payable_discount     :decimal(25, 10)  default(0.0)
#  payable_total        :decimal(25, 10)  default(0.0)
#  payable_invoice_date :date
#  payable_due_date     :date
#  payable_notes        :text(65535)
#  payable_status       :string(255)
#  payable_active       :boolean
#  payable_created_id   :integer
#  payable_updated_id   :integer
#  created_at           :datetime
#  updated_at           :datetime
#  payable_freight      :decimal(25, 10)  default(0.0)
#  payable_invoice      :string(255)
#  gl_account_id        :integer
#  payable_type         :string(255)
#  payable_disperse     :string(255)
#

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
