class Territory < ActiveRecord::Base
  attr_accessible :territory_active, :territory_created_id, :territory_description, :territory_identifier, :territory_updated_id, :territory_zip
end
