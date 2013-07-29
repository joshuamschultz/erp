class Specification < ActiveRecord::Base
  after_initialize :default_values

  def default_values
    self.specification_active = true if self.specification_active.nil?
  end

  attr_accessible :specification_active, :specification_created_id, :specification_description, 
  :specification_identifier, :specification_notes, :specification_updated_id

  (validates_uniqueness_of :specification_identifier if validates_length_of :specification_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :specification_identifier

  validates_length_of :specification_description, :specification_notes, :maximum => 50
end
