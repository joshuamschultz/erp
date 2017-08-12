# == Schema Information
#
# Table name: group_organizations
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  group_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class GroupOrganization < ActiveRecord::Base
	attr_accessible :organization_id, :group_id

	belongs_to :organization
	belongs_to :group
	# attr_accessible :title, :body
end
