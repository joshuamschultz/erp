require 'spec_helper'

describe Attachment do

  it "has a valid attachment" do
     FactoryGirl.create(:attachment).should be_valid
  end
end
