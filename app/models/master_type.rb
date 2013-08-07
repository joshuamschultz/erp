class MasterType < ActiveRecord::Base
  attr_accessible :type_active, :type_category, :type_description, :type_name, :type_value

  has_many :owners, :class_name => "Owner", :foreign_key => "owner_commission_type_id"

  has_many :type_based_organizations, :class_name => "Organization", :foreign_key => "organization_type_id"

  has_many :contact_based_organizations, :class_name => "Organization", :foreign_key => "customer_contact_type_id"

  has_many :type_based_pos, :class_name => "PoHeader", :foreign_key => "po_type_id"

  validates_uniqueness_of :type_value

  # owner / commission_type -> Sell * quantityshipped, [sell-cost]*quantityshipped
  # customer quality level / forms -> 
  # organization -> type - customer, vendor, support
  # po -> type - 
end
