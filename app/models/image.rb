class Image < ActiveRecord::Base
  attr_accessible :image_active, :image_content_type, :image_created_id, :image_description, :image_file_name, :image_file_size, :image_notes, :image_public, :image_title, :image_updated_id, :imageable_id, :imageable_type
end
