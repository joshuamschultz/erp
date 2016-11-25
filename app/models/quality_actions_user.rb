class QualityActionsUser < ActiveRecord::Base
  belongs_to :quality_action
  belongs_to :user
  attr_accessor :quality_action_id, :user_id
end
