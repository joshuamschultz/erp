# == Schema Information
#
# Table name: comments
#
#  id                 :integer          not null, primary key
#  comment            :string(255)
#  comment_type       :string(255)
#  commentable_id     :integer
#  commentable_type   :string(255)
#  comment_active     :boolean
#  comment_created_id :integer
#  comment_updated_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :created_by, :class_name => "User", :foreign_key => "comment_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "comment_updated_id"

  validates_presence_of :comment
  validates_presence_of :commentable

  after_initialize :default_values

  def default_values
	   self.comment_active = true if self.comment_active.nil?
  end

  # comment_type - tag/note

  def self.process_comments(current_user, commentable, comments, type)
    if type == "tag"
      commentable.comments.where(:comment_type => "tag").destroy_all
    end
    if comments
      comments.each do |comment|
        comment = commentable.comments.new(:comment => comment, :comment_type => type)
        comment = CommonActions.record_ownership(comment, current_user)
        comment.save
      end
    end
  end

end
