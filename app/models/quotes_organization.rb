class QuotesOrganization < ActiveRecord::Base
  attr_accessible :organization_id, :quote_id
  belongs_to :organization
  belongs_to :quote
end
