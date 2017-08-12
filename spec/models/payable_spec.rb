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

require 'spec_helper'

describe Payable do
  it "has a valid factory" do
  	 FactoryGirl.create(:payable).should be_valid
  end
  it "is invalid without vendor" do 
  	FactoryGirl.build(:payable, organization_id: nil).should_not be_valid 
  end 
  it "is invalid without a vendor invoice" do 
  	FactoryGirl.build(:payable, payable_invoice: nil).should_not be_valid 
  end 
  it "is invalid without a invoice date" do 
  	FactoryGirl.build(:payable, payable_invoice_date: nil).should_not be_valid 
  end 
  it "is invalid without a due date" do 
  	FactoryGirl.build(:payable, payable_due_date: nil).should_not be_valid 
  end 
 end
