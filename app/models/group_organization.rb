class GroupOrganization < ActiveRecord::Base
	attr_accessible :organization_id, :group_id

	belongs_to :organization
	belongs_to :group
	# attr_accessible :title, :body
end