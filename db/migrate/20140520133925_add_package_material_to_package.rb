class AddPackageMaterialToPackage < ActiveRecord::Migration
  def change
  	add_column :packages, :dunnage_manufacturer, :text
  	add_column :packages, :container_color_manufacturer, :text
  	add_column :packages, :container_type_manufacturer, :text
  	add_column :packages, :cover_cap_manufacturer, :text
  	add_column :packages, :pallet_manufacturer, :text
  	add_column :packages, :strech_shrink_manufacturer, :text
  	add_column :packages, :banding_manufacturer, :text
  	add_column :packages, :other_manufacturer, :text

  	add_column :packages, :dunnage_material, :text
  	add_column :packages, :container_color_material, :text
  	add_column :packages, :container_type_material, :text
  	add_column :packages, :cover_cap_material, :text
  	add_column :packages, :pallet_material, :text
  	add_column :packages, :strech_shrink_material, :text
  	add_column :packages, :banding_material, :text
  	add_column :packages, :other_material, :text

  	add_column :packages, :dunnage_lead_time, :text
  	add_column :packages, :container_color_lead_time, :text
  	add_column :packages, :container_type_lead_time, :text
  	add_column :packages, :cover_cap_lead_time, :text
  	add_column :packages, :pallet_lead_time, :text
  	add_column :packages, :strech_shrink_lead_time, :text
  	add_column :packages, :banding_lead_time, :text
  	add_column :packages, :other_lead_time, :text

  	add_column :packages, :dunnage_ret_exp, :text
  	add_column :packages, :container_color_ret_exp, :text
  	add_column :packages, :container_type_ret_exp, :text
  	add_column :packages, :cover_cap_ret_exp, :text
  	add_column :packages, :pallet_ret_exp, :text
  	add_column :packages, :strech_shrink_ret_exp, :text
  	add_column :packages, :banding_ret_exp, :text
  	add_column :packages, :other_ret_exp, :text

  	add_column :packages, :dunnage_comment, :text 
  	add_column :packages, :container_color_comment, :text
  	add_column :packages, :container_type_comment, :text
  	add_column :packages, :cover_cap_comment, :text
  	add_column :packages, :pallet_comment, :text
  	add_column :packages, :strech_shrink_comment, :text
  	add_column :packages, :banding_comment, :text
  	add_column :packages, :other_comment, :text
  end
end
