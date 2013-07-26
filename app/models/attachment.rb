class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :attachment_active, :attachment_content_type, :attachment_created_id, :attachment_description, :attachment_file_name, :attachment_file_size, :attachment_notes, :attachment_public, :attachment_title, :attachment_updated_id
end
