# == Schema Information
#
# Table name: customer_feedbacks
#
#  id                        :integer          not null, primary key
#  organization_id           :integer
#  title                     :string(255)
#  feedback                  :text(65535)
#  quality_action_id         :integer
#  user_id                   :integer
#  created_at                :datetime
#  updated_at                :datetime
#  customer_feedback_type_id :integer
#

class CustomerFeedback < ActiveRecord::Base

  has_many :attachments, :as => :attachable, :dependent => :destroy

  belongs_to :organization
  belongs_to :quality_action
  belongs_to :user
  belongs_to :customer_feedback_type, -> {where type_category:  'customer_response'}, :class_name => "MasterType",
                                                                                    :foreign_key => "customer_feedback_type_id"

  validates_presence_of :organization, :user

end
