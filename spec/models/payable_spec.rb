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
