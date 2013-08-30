class ProcessFlow < ActiveRecord::Base
  attr_accessible :process_active, :process_created_id, :process_description, 
  :process_identifier, :process_name, :process_notes, :process_updated_id
end
