class Material < ActiveRecord::Base
  attr_accessible :material_active, :material_created_id, 
  					:material_description, :material_notes, 
  					:material_short_name, :material_updated_id

  (validates_uniqueness_of :material_short_name if validates_length_of :material_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :material_short_name

  (validates_length_of :material_description, :minimum => 2, :maximum => 50) if validates_presence_of :material_description

  validates_length_of :material_notes, :maximum => 200

  has_many :material_elements, :dependent => :destroy

  belongs_to :created_by, :class_name => "User", :foreign_key => "material_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "material_updated_id"

end
