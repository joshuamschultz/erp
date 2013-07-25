class Comment < ActiveRecord::Base
  attr_accessible :comment, :comment_active, :comment_created_id, :comment_updated_id, 
  :commentable_id, :commentable_type, :comment_type

  after_initialize :default_values

  def default_values
	self.comment_active ||= true
  end

  validates_presence_of :comment

  validates_presence_of :commentable

  belongs_to :commentable, :polymorphic => true

  belongs_to :created_by, :class_name => "User", :foreign_key => "comment_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "comment_updated_id"

  # comment_type - tag/note
end
