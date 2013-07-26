class Gauge < ActiveRecord::Base
  belongs_to :organization
  has_many :dimensions
  
  attr_accessible :organization_id, :gage_caliberaion_period, :gage_caliberation_at, :gauge_active, 
  :gauge_created_id, :gauge_tool_name, :gauge_tool_no, :gauge_updated_id
end
