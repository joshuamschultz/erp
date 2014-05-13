class QualityActionsUser < ActiveRecord::Base
  belongs_to :quality_action
  belongs_to :user
  attr_accessible :quality_action_id, :user_id
end
