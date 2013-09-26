class QuoteVendor < ActiveRecord::Base
  belongs_to :quote
  belongs_to :organization
  
  attr_accessible :quote_vendor_created_id, :quote_vendor_status, 
  :quote_vendor_updated_id, :quote_id, :organization_id
end
