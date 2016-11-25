class Logo < ActiveRecord::Base
	attr_accessible :joint_active, :joint_content_type, :joint_created_id, :joint_description, 
  :joint_file_name, :joint_file_size, :joint_notes, :joint_public, :joint_title, :joint_updated_id, 
  :jointable_id, :jointable_type, :joint

  	belongs_to :jointable, :polymorphic => true
    


  	  has_attached_file :joint, :url  => "/attachments/joints/:id/:style/:basename.:extension", 
  :path => ":rails_root/public/attachments/joints/:id/:style/:basename.:extension"


	# validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
	validates_presence_of :joint


  	before_create :before_create_process

	def before_create_process
	  	if self.jointable_type =="QualityDocument"
			# self.joint_file_name=new_quote_identifier+"."+(self.joint_file_name).split('.')[-1]
			quality_document = QualityDocument.find(self.jointable_id)
			self.joint_file_name= quality_document.quality_document_name+"."+(self.joint_file_name).match(/(.*)\.(.*)/)[1..2][1]

			type_name = (self.joint_file_name).match(/(.*)\.(.*)/)[1..2][0]

			unless MasterType.find_by_quality_document_id(self.jointable_id)
				MasterType.create(type_name: type_name, type_description: "", type_value: type_name, type_category: "customer_quality_level", type_active: true, quality_document_id: self.jointable_id)
			else
				@master_type = MasterType.find_by_quality_document_id(self.jointable_id)
				@master_type.update_attributes(:type_name => type_name, :type_value => type_name)
			end
  		end
  	end


end
