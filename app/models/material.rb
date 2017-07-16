# == Schema Information
#
# Table name: materials
#
#  id                   :integer          not null, primary key
#  material_short_name  :string(255)
#  material_description :string(255)
#  material_notes       :text(65535)
#  material_active      :boolean          default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#

class Material < ActiveRecord::Base
  attr_accessible :material_active, :material_created_id, 
  					:material_description, :material_notes, 
  					:material_short_name, :material_updated_id

  after_initialize :default_values

  def default_values
    self.material_active = true if self.attributes.has_key?("material_active") && self.material_active.nil?
  end

  (validates_uniqueness_of :material_short_name if validates_length_of :material_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :material_short_name

  (validates_length_of :material_description, :minimum => 2, :maximum => 50) if validates_presence_of :material_description

  validates_length_of :material_notes, :maximum => 200

  has_many :material_elements, :dependent => :destroy
  # has_many :item_materials, :dependent => :destroy
  # has_many :item_revisions, :through => :item_materials
  has_many :item_revisions

  belongs_to :created_by, :class_name => "User", :foreign_key => "material_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "material_updated_id"
end
