class Element < ActiveRecord::Base
  attr_accessible :element_active, :element_created_id, :element_name, :element_notes, :element_symbol, :element_updated_id
end
