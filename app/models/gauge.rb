class Gauge < ActiveRecord::Base  
  attr_accessible :organization_id, :gage_caliberaion_period, :gage_caliberation_at, :gauge_active, 
  :gauge_created_id, :gauge_tool_name, :gauge_tool_no, :gauge_updated_id

  after_initialize :default_values

  def default_values
	   self.gauge_active = true if self.gauge_active.nil?
  end

  belongs_to :organization
  has_many :dimensions
end
