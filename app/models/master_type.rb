class MasterType < ActiveRecord::Base
  attr_accessible :type_active, :type_category, :type_description, :type_name, :type_value

  has_many :owners, :class_name => "Owner", :foreign_key => "owner_commission_type_id"

  validates_uniqueness_of :type_value

  # owner / commission_type -> Sell * quantityshipped, [sell-cost]*quantityshipped
  # sustomer quality level / forms -> 
end
