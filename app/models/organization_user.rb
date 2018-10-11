# == Schema Information
#
# Table name: organization_users
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  user_id         :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class OrganizationUser < ActiveRecord::Base
  attr_accessor :organization_id, :user_id
  belongs_to :organization
  belongs_to :user
end
