class MaterialElement < ActiveRecord::Base
  belongs_to :material
  attr_accessible :material_id, :element_active, :element_created_id, :element_high_range, :element_low_range, :element_name, :element_symbol, :element_updated_id

  belongs_to :created_by, :class_name => "User", :foreign_key => "element_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "element_updated_id"
end
