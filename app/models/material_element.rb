class MaterialElement < ActiveRecord::Base
  belongs_to :material
  attr_accessible :material_id, :element_active, :element_created_id, :element_high_range, :element_low_range, :element_name, :element_symbol, :element_updated_id

  (validates_uniqueness_of :element_symbol if validates_length_of :element_symbol, :minimum => 2, :maximum => 10) if validates_presence_of :element_symbol
  (validates_length_of :element_name, :minimum => 2, :maximum => 50) if validates_presence_of :element_name


  belongs_to :created_by, :class_name => "User", :foreign_key => "element_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "element_updated_id"
end
