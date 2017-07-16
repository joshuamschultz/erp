# == Schema Information
#
# Table name: packages
#
#  id                           :integer          not null, primary key
#  quality_lot_id               :integer
#  part_size_length             :decimal(10, )
#  part_size_width              :decimal(10, )
#  part_size_height             :decimal(10, )
#  container_length             :decimal(10, )
#  container_width              :decimal(10, )
#  container_height             :decimal(10, )
#  pallet_length                :decimal(10, )
#  pallet_width                 :decimal(10, )
#  pallet_height                :decimal(10, )
#  load_shipped_length          :decimal(10, )
#  load_shipped_width           :decimal(10, )
#  load_shipped_height          :decimal(10, )
#  part_weight                  :decimal(10, )
#  dunnage_tare_Weight          :decimal(10, )
#  container_tare_weight        :decimal(10, )
#  pallet_tare_weight           :decimal(10, )
#  container_gross_inc_weight   :decimal(10, )
#  unit_load_gross              :decimal(10, )
#  quantity_per_container       :integer
#  container_per_layer_pallet   :integer
#  layers_per_pallet            :integer
#  container_per_pallet         :integer
#  package_comment              :text(65535)
#  part_content_type            :string(255)
#  part_file_size               :integer
#  part_updated_at              :datetime
#  part_file_name               :string(255)
#  container_content_type       :string(255)
#  container_file_size          :integer
#  container_updated_at         :datetime
#  container_file_name          :string(255)
#  dunnage_content_type         :string(255)
#  dunnage_file_size            :integer
#  dunnage_updated_at           :datetime
#  dunnage_file_name            :string(255)
#  unit_load_content_type       :string(255)
#  unit_load_file_size          :integer
#  unit_load_updated_at         :datetime
#  unit_load_file_name          :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  dunnage_manufacturer         :text(65535)
#  container_color_manufacturer :text(65535)
#  container_type_manufacturer  :text(65535)
#  cover_cap_manufacturer       :text(65535)
#  pallet_manufacturer          :text(65535)
#  strech_shrink_manufacturer   :text(65535)
#  banding_manufacturer         :text(65535)
#  other_manufacturer           :text(65535)
#  dunnage_material             :text(65535)
#  container_color_material     :text(65535)
#  container_type_material      :text(65535)
#  cover_cap_material           :text(65535)
#  pallet_material              :text(65535)
#  strech_shrink_material       :text(65535)
#  banding_material             :text(65535)
#  other_material               :text(65535)
#  dunnage_lead_time            :text(65535)
#  container_color_lead_time    :text(65535)
#  container_type_lead_time     :text(65535)
#  cover_cap_lead_time          :text(65535)
#  pallet_lead_time             :text(65535)
#  strech_shrink_lead_time      :text(65535)
#  banding_lead_time            :text(65535)
#  other_lead_time              :text(65535)
#  dunnage_ret_exp              :text(65535)
#  container_color_ret_exp      :text(65535)
#  container_type_ret_exp       :text(65535)
#  cover_cap_ret_exp            :text(65535)
#  pallet_ret_exp               :text(65535)
#  strech_shrink_ret_exp        :text(65535)
#  banding_ret_exp              :text(65535)
#  other_ret_exp                :text(65535)
#  dunnage_comment              :text(65535)
#  container_color_comment      :text(65535)
#  container_type_comment       :text(65535)
#  cover_cap_comment            :text(65535)
#  pallet_comment               :text(65535)
#  strech_shrink_comment        :text(65535)
#  banding_comment              :text(65535)
#  other_comment                :text(65535)
#  in_to_mm1                    :decimal(10, )
#  in_to_mm2                    :decimal(10, )
#  lbs_to_kg1                   :decimal(10, )
#  lbs_to_kg2                   :decimal(10, )
#  supplier_code                :string(255)
#

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
