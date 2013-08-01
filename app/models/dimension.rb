class Dimension < ActiveRecord::Base
  attr_accessible :dimension_active, :dimension_created_id, :dimension_description, 
  :dimension_identifier, :dimension_notes, :dimension_updated_id, :gauge_id

  after_initialize :default_values

  def default_values
	   self.dimension_active = true if self.dimension_active.nil?
  end

  belongs_to :gauge
  has_many :item_part_dimensions, :dependent => :destroy

  validates_presence_of :gauge
  (validates_uniqueness_of :dimension_identifier if validates_length_of :dimension_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :dimension_identifier
 
end
