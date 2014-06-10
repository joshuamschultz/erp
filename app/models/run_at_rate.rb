class RunAtRate < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	attr_accessible :run_at_rate_active, :run_at_rate_created_id, :run_at_rate_description, 
					  :run_at_rate_name, :run_at_rate_notes, :run_at_rate_updated_id,:attachment_attributes

	after_initialize :default_values

	def default_values
	self.run_at_rate_active = true if self.attributes.has_key?("run_at_rate_active") && self.run_at_rate_active.nil?
	end

	has_one :attachment, :as => :attachable, :dependent => :destroy
	has_many :quality_lots

	accepts_nested_attributes_for :attachment, :allow_destroy => true


	def redirect_path
	  run_at_rate_type_path(self)
	end

	before_save :before_save_values

	def before_save_values
	  self.run_at_rate_name = self.attachment.attachment_name
	end
end
