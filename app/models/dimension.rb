class Dimension < ActiveRecord::Base
  belongs_to :gauge
  
  attr_accessible :dimension_active, :dimension_created_id, :dimension_description, 
  :dimension_identifier, :dimension_notes, :dimension_updated_id
end
