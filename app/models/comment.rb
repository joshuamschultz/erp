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

  def self.process_organization_comments(current_user, organization, comments, type)
      if type == "tag"
          organization.comments.where(:comment_type => "tag").destroy_all
      end

      if comments
          comments.each do |comment|
              comment = organization.comments.new(:comment => comment, :comment_type => type)
              comment = CommonActions.record_ownership(comment, current_user) 
              comment.save
          end
      end   
  end

end
