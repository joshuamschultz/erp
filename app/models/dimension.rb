class Dimension < ActiveRecord::Base
  attr_accessible :dimension_active, :dimension_created_id, :dimension_description, 
  :dimension_identifier, :dimension_notes, :dimension_updated_id  

  after_initialize :default_values

  def default_values
	   self.dimension_active = true if self.dimension_active.nil?
  end

  belongs_to :gauge  
  
end
