class CapacityPlanning < ActiveRecord::Base
		include Rails.application.routes.url_helpers

  attr_accessible :capacity_plan_active, :capacity_plan_created_id, :capacity_plan_description,
  				:capacity_plan_name, :capacity_plan_notes, :capacity_plan_updated_id, :attachment_attributes

  	after_initialize :default_values

	def default_values
	self.capacity_plan_active = true if self.attributes.has_key?("capacity_plan_active") && self.capacity_plan_active.nil?
	end

	has_one :attachment, :as => :attachable, :dependent => :destroy

	accepts_nested_attributes_for :attachment, :allow_destroy => true


	def redirect_path
	  capacity_planning_type_path(self)
	end

	before_save :before_save_values

	def before_save_values
	  sel_name = self.attachment.attachment_name
	end
end
