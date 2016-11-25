class Dimension < ActiveRecord::Base  

  after_initialize :default_values

  def default_values
	   self.dimension_active = true if self.dimension_active.nil?
  end
  
  has_many :item_part_dimensions, :dependent => :destroy

  (validates_uniqueness_of :dimension_identifier if validates_length_of :dimension_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :dimension_identifier
 
end
