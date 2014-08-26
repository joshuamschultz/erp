class Logo < ActiveRecord::Base
	attr_accessible :joint_active, :joint_content_type, :joint_created_id, :joint_description, 
  :joint_file_name, :joint_file_size, :joint_notes, :joint_public, :joint_title, :joint_updated_id, 
  :jointable_id, :jointable_type, :joint

  	belongs_to :jointable, :polymorphic => true

  	has_attached_file :joint, :styles => {:original => "400x400", :medium =>"200x200", :thumb => "120x120>"}, 
  	:url  => "/attachments/joints/:id/:style/:basename.:extension", 
  	:path => ":rails_root/public/attachments/joints/:id/:style/:basename.:extension"

	# validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
	validates_presence_of :joint
end
