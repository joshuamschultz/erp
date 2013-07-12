class MasterType < ActiveRecord::Base
  attr_accessible :type_active, :type_category, :type_description, :type_name

  has_many :owners, :class_name => "Owner", :foreign_key => "owner_commission_type_id"

  # owner commission_type -> Sell * quantityshipped, [sell-cost]*quantityshipped
end
