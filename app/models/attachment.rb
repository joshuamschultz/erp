class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :attachment_revision_title, :attachment_revision_date,
  :attachment_effective_date, :attachment_name, :attachment_description, :attachment_document_type,
  :attachment_document_type_id, :attachment_notes, :attachment_public, :attachment_active, 
  :attachment_status, :attachment_status_id, :attachment_created_id, :attachment_updated_id, :attachment

  belongs_to :attachable, :polymorphic => true

  has_attached_file :attachment, :url  => "/attachments/documents/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/documents/:id/:style/:basename.:extension"

  # validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
  
  validates_presence_of :attachment_revision_title

  validates_presence_of :attachment_name

  validates_presence_of :attachment

  # attachment_status - pending/approved/rejected

  before_create :create_level_default

  def create_level_default
      self.attachment_status = "pending"
      # self.attachment_active = false
  end

end
