class CustomerFeedback < ActiveRecord::Base  
  attr_accessible :feedback, :quality_action_id, :title, :organization_id, :user_id
  belongs_to :organization
  # belongs_to :quality_action_id
  belongs_to :user
  validates_presence_of :organization, :user

end
