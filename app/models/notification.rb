class Notification < ActiveRecord::Base
  attr_accessible :notable_id, :notable_type, :note_status, :user_id
  belongs_to :notable, :polymorphic => true
end
