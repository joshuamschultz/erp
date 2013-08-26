class MaterialElement < ActiveRecord::Base
  belongs_to :material
  belongs_to :element

  attr_accessible :material_id, :element_active, :element_created_id, 
  :element_high_range, :element_low_range, :element_name, :element_symbol, 
  :element_updated_id, :element_id

  after_initialize :default_values

  def default_values
    self.element_active = true if self.element_active.nil?
  end

  # validates_length_of :element_symbol, :maximum => 20 if validates_presence_of :element_symbol
  # validates_uniqueness_of :element_name if validates_length_of :element_name, :maximum => 50 if validates_presence_of :element_name
  validates_presence_of :element, :element_high_range, :element_low_range
  validates :element_id, :uniqueness => { :scope => :material_id, :message => "already exists!" }

  belongs_to :created_by, :class_name => "User", :foreign_key => "element_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "element_updated_id"
end
