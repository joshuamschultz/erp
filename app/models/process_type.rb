class ProcessType < ActiveRecord::Base
  attr_accessible :process_active, :process_created_id, :process_description, :process_notes, :process_short_name, :process_updated_id
end
