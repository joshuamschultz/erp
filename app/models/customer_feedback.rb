class CustomerFeedback < ActiveRecord::Base
  include Rails.application.routes.url_helpers


  belongs_to :organization
  belongs_to :quality_action
  belongs_to :user
  validates_presence_of :organization, :user

 belongs_to :customer_feedback_type, -> {where type_category:  'customer_response'}, :class_name => "MasterType",
                                                                                    :foreign_key => "customer_feedback_type_id"
  has_many :attachments, :as => :attachable, :dependent => :destroy

  def redirect_path
      customer_feedback_path(self)
  end
end
