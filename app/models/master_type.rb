class MasterType < ActiveRecord::Base
  attr_accessible :type_active, :type_category, :type_description, :type_name, :type_value

  scope :po_types, where(:type_category => 'po_type')

  scope :organization_types, where(:type_category => 'organization_type')

  scope :quality_levels, where(:type_category => 'customer_quality_level')

  scope :payment_types, where(:type_category => 'payment_type')

  has_many :owners, :class_name => "Owner", :foreign_key => "owner_commission_type_id"

  has_many :type_based_organizations, :class_name => "Organization", :foreign_key => "organization_type_id"

  has_many :contact_based_organizations, :class_name => "Organization", :foreign_key => "customer_contact_type_id"

  has_many :type_based_pos, :class_name => "PoHeader", :foreign_key => "po_type_id"

  has_many :level_based_lots, :class_name => "QualityLot", :foreign_key => "inspection_level_id"
  has_many :method_based_lots, :class_name => "QualityLot", :foreign_key => "inspection_method_id"
  has_many :type_based_lots, :class_name => "QualityLot", :foreign_key => "inspection_type_id"

  has_many :type_based_payments, :class_name => "Payment", :foreign_key => "payment_type_id"

  has_many :customer_quality_levels, :dependent => :destroy
  has_many :customer_qualities, :through => :customer_quality_levels

  # validates_uniqueness_of :type_value

  # owner / commission_type -> Sell * quantityshipped, [sell-cost]*quantityshipped
  # customer quality level / forms -> 
  # organization -> type - customer, vendor, support
  # po -> type - 
end
