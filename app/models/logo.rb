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
			self.joint_file_name=new_quote_identifier+"."+(self.joint_file_name).match(/(.*)\.(.*)/)[1..2][1]

			unless MasterType.find_by_quality_document_id(self.jointable_id)
				MasterType.create(type_name: self.joint_file_name, type_description: "", type_value: self.joint_file_name, type_category: "customer_quality_level", type_active: true, quality_document_id: self.jointable_id)
			else
			@master_type = MasterType.find_by_quality_document_id(self.jointable_id)
			@master_type.update_attributes(:type_name => self.joint_file_name, :type_value => self.joint_file_name)
			end
  		end
  	end

	def new_quote_identifier
		quote_identifier = Time.now.strftime("%m%y") + ("%03d" % (Logo.where("month(created_at) = ?", Date.today.month).count + 1))
		quote_identifier.slice!(2)
		"Form" + quote_identifier
	end
end
