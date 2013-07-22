class Organization < ActiveRecord::Base
  belongs_to :user
  belongs_to :territory
  belongs_to :customer_quality
  belongs_to :vendor_quality

  after_initialize :default_values

  def default_values
    self.organization_active ||= true
  end

  belongs_to :organization_type, :class_name => "MasterType", :foreign_key => "organization_type_id", 
  :conditions => ['type_category = ?', 'organization_type']

  belongs_to :contact_type, :class_name => "MasterType", :foreign_key => "customer_contact_type_id", 
  :conditions => ['type_category = ?', 'customer_contact_type']

  belongs_to :max_vendor_quality, :class_name => "VendorQuality", :foreign_key => "customer_max_quality_id"

  attr_accessible :customer_contact_type_id, :customer_max_quality_id, :organization_active, 
  :organization_created_id, :organization_description, :organization_name, :organization_notes, 
  :organization_short_name, :organization_type_id, :organization_updated_id, :vendor_expiration_date,
  :user_id, :territory_id, :customer_quality_id, :vendor_quality_id
end
