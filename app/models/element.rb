class Element < ActiveRecord::Base
  attr_accessible :element_active, :element_created_id, :element_name, :element_notes, :element_symbol, :element_updated_id
  has_many :material_elements


  after_initialize :default_values 
  
  def default_values
  		self.element_active = true if self.attributes.has_key?("element_active") && self.element_active.nil?
	   	# self.element_active = true if self.element_active.nil?
  end  

end
