class CustomerFeedback < ActiveRecord::Base  
  include Rails.application.routes.url_helpers
  
  attr_accessible :feedback, :quality_action_id, :title, :organization_id, :user_id, :customer_feedback_type_id
  belongs_to :organization
  belongs_to :quality_action
  belongs_to :user
  validates_presence_of :organization, :user

  belongs_to :customer_feedback_type, :class_name => "MasterType", :foreign_key => "customer_feedback_type_id",
	    :conditions => ['type_category = ?', 'customer_response']
  has_many :attachments, :as => :attachable, :dependent => :destroy

  def redirect_path
      customer_feedback_path(self)
  end
end
