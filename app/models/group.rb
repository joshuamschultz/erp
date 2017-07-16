# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  group_name :string(255)
#  group_type :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Group < ActiveRecord::Base
  attr_accessible :group_name, :group_type

  has_many :organizations, through: :group_organizations
  has_many :group_organizations, dependent: :destroy
  has_many :quotes

  def self.process_group_associations(group, params)
    if group
      vendors = params[:vendors] || []
      group.group_organizations.where.not(organization_id: vendors).destroy_all

      if vendors
        vendors.each do |vendor_id|
          unless group.group_organizations.find_by_organization_id(vendor_id)
            group_vendor = group.group_organizations.new(organization_id: vendor_id)
            group_vendor.save
            end
        end
      end
    end
  end
end
