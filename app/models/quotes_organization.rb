# == Schema Information
#
# Table name: quotes_organizations
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  quote_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class QuotesOrganization < ActiveRecord::Base
  attr_accessible :organization_id, :quote_id
  belongs_to :organization
  belongs_to :quote
end
