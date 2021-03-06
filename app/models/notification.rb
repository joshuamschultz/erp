# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  notable_id   :integer
#  notable_type :string(255)
#  note_status  :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Notification < ActiveRecord::Base
  belongs_to :notable, :polymorphic => true
end
