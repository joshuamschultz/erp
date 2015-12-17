class Gauge < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :organization_id, :gage_caliberaion_period, :gage_caliberation_last_at,
  :gage_caliberation_due_at, :gauge_active, :gauge_created_id, :gauge_tool_name, :gauge_tool_no,
  :gauge_updated_id, :gauge_tool_category

  after_initialize :default_values

  def default_values
	   self.gauge_active = true if self.gauge_active.nil?
  end

  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("support").id]

  has_many :item_part_dimensions
  has_many :attachments, :as => :attachable, :dependent => :destroy

  	def redirect_path
      	gauge_path(self)
	end

  def self.get_this_week_gauges
     Gauge.where("gage_caliberation_due_at <= ?", Date.today+6)
  end

end
