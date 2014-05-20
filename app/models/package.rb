class Package < ActiveRecord::Base
  attr_accessible :container_content_type, :container_file_name, :container_file_size, :container_gross_inc_weight,
  	:container_height, :container_length, :container_per_layer_pallet, :container_per_pallet, :container_tare_weight, 
  	:container_updated_at, :container_width, :dunnage_content_type, :dunnage_file_name, :dunnage_file_size, 
  	:dunnage_tare_Weight, :dunnage_updated_at, :layers_per_pallet, :load_shipped_height, :load_shipped_length, 
  	:load_shipped_width, :package_comment, :pallet_height, :pallet_length, :pallet_tare_weight, :pallet_width, 
  	:part_content_type, :part_file_name, :part_file_size, :part_size_height, :part_size_length, :part_size_width, 
  	:part_updated_at, :part_weight, :quantity_per_container, :unit_load_content_type, :unit_load_file_name, 
  	:unit_load_file_size, :unit_load_gross, :unit_load_updated_at, :quality_lot_id, :part, :container, :dunnage, :unit_load,
  	:dunnage_manufacturer ,:container_color_manufacturer ,:container_type_manufacturer ,:cover_cap_manufacturer ,:pallet_manufacturer ,
  	:strech_shrink_manufacturer ,:banding_manufacturer ,:other_manufacturer,:dunnage_material , :container_color_material ,:container_type_material ,
  	:cover_cap_material ,:pallet_material ,:strech_shrink_material ,:banding_material ,:other_material, :dunnage_lead_time ,:container_color_lead_time ,
  	:container_type_lead_time ,:cover_cap_lead_time ,:pallet_lead_time ,:strech_shrink_lead_time ,:banding_lead_time ,:other_lead_time, :dunnage_ret_exp ,
  	:container_color_ret_exp ,:container_type_ret_exp ,:cover_cap_ret_exp ,:pallet_ret_exp ,:strech_shrink_ret_exp ,:banding_ret_exp ,:other_ret_exp,
  	:dunnage_comment ,:container_color_comment ,:container_type_comment ,:cover_cap_comment ,:pallet_comment ,:strech_shrink_comment ,:banding_comment ,:other_comment



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
