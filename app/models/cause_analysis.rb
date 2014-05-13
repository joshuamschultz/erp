class CauseAnalysis < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	attr_accessible :active, :created_id, :description, :name, :notes, :updated_id, :attachment_attributes

	after_initialize :default_values

	has_many :quality_actions

	def default_values
		self.active = true if self.attributes.has_key?("active") && self.active.nil?
	end

	has_one :attachment, :as => :attachable, :dependent => :destroy

	accepts_nested_attributes_for :attachment, :allow_destroy => true


	def redirect_path
	  cause_analyasis_path(self)
	end

	before_save :before_save_values

	def before_save_values
	  self.name = self.attachment.attachment_name
	end

  
end
