class Package < ActiveRecord::Base  



    belongs_to :quality_lot



  has_attached_file :part, :url  => "/attachments/package_image/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/package_image/:id/:style/:basename.:extension"

  has_attached_file :container, :url  => "/attachments/package_image/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/package_image/:id/:style/:basename.:extension"

  has_attached_file :dunnage, :url  => "/attachments/package_image/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/package_image/:id/:style/:basename.:extension"

  has_attached_file :unit_load, :url  => "/attachments/package_image/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/package_image/:id/:style/:basename.:extension"

  # validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']

  validates_presence_of :part, :container, :dunnage, :unit_load, :quality_lot
end
