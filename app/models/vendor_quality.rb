class VendorQuality < ActiveRecord::Base
  attr_accessible :quality_active, :quality_created_id, :quality_description, :quality_name, 
  :quality_notes, :quality_updated_id
end
