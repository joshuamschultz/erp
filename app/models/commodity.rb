class Commodity < ActiveRecord::Base
  attr_accessible :commodity_active, :commodity_created_id, :commodity_description, :commodity_identifier, :commodity_notes, :commodity_updated_id
end
