# == Schema Information
#
# Table name: gauges
#
#  id                        :integer          not null, primary key
#  organization_id           :integer
#  gauge_tool_name           :string(255)
#  gauge_tool_category       :string(255)
#  gauge_tool_no             :string(255)
#  gage_caliberation_last_at :date
#  gage_caliberation_due_at  :date
#  gage_caliberaion_period   :integer
#  gauge_active              :boolean
#  gauge_created_id          :integer
#  gauge_updated_id          :integer
#  created_at                :datetime
#  updated_at                :datetime
#

class Gauge < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  

  after_initialize :default_values

  def default_values
	   self.gauge_active = true if self.gauge_active.nil?
  end

  belongs_to :organization, -> {where organization_type_id:  MasterType.find_by_type_value("support").id}

  has_many :item_part_dimensions
  has_many :attachments, :as => :attachable, :dependent => :destroy

  	def redirect_path
      	gauge_path(self)
	end

  def self.get_this_week_gauges
     Gauge.where("gage_caliberation_due_at <= ?", Date.today+6)
  end

end
