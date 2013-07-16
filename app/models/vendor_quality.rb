class VendorQuality < ActiveRecord::Base
  attr_accessible :quality_active, :quality_created_id, :quality_description, :quality_name, 
  :quality_notes, :quality_updated_id


  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 2, :maximum => 50) if validates_presence_of :quality_name

  validates_length_of :quality_description, :maximum => 50

  validates_length_of :quality_notes, :maximum => 200
end
