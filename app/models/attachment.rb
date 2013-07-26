class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :attachment_active, :attachment_content_type, 
  :attachment_created_id, :attachment_description, :attachment_file_name, :attachment_file_size, 
  :attachment_notes, :attachment_public, :attachment_title, :attachment_updated_id, :attachment

  belongs_to :attachable, :polymorphic => true

  has_attached_file :attachment, :url  => "/attachments/documents/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/documents/:id/:style/:basename.:extension"

  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
  
  validates_presence_of :attachment_title

  validates_presence_of :attachment_description

  validates_presence_of :attachment_notes

  validates_presence_of :attachment
end
