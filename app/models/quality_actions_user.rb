# == Schema Information
#
# Table name: quality_actions_users
#
#  id                :integer          not null, primary key
#  quality_action_id :integer
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class QualityActionsUser < ActiveRecord::Base
  belongs_to :quality_action
  belongs_to :user
  attr_accessor :quality_action_id, :user_id
end
