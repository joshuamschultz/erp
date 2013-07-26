class Image < ActiveRecord::Base
  attr_accessible :image_active, :image_content_type, :image_created_id, :image_description, 
  :image_file_name, :image_file_size, :image_notes, :image_public, :image_title, :image_updated_id, 
  :imageable_id, :imageable_type, :image

  	belongs_to :imageable, :polymorphic => true

  	has_attached_file :image, :styles => {:original => "400x400", :medium =>"200x200", :thumb => "120x120>"}, 
  	:url  => "/attachments/images/:id/:style/:basename.:extension", 
  	:path => ":rails_root/public/attachments/images/:id/:style/:basename.:extension"

	# validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
	validates_presence_of :image
end
