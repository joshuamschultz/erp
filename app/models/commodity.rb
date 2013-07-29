class Commodity < ActiveRecord::Base
  after_initialize :default_values

  def default_values
    self.commodity_active = true if self.commodity_active.nil?
  end
  
  attr_accessible :commodity_active, :commodity_created_id, :commodity_description, 
  :commodity_identifier, :commodity_notes, :commodity_updated_id

  (validates_uniqueness_of :commodity_identifier if validates_length_of :commodity_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :commodity_identifier

  validates_length_of :commodity_description, :commodity_notes, :maximum => 50
end