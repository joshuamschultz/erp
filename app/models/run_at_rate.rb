# == Schema Information
#
# Table name: run_at_rates
#
#  id                      :integer          not null, primary key
#  run_at_rate_name        :string(255)
#  run_at_rate_description :string(255)
#  run_at_rate_notes       :text(65535)
#  run_at_rate_active      :boolean
#  run_at_rate_created_id  :integer
#  run_at_rate_updated_id  :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class RunAtRate < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	
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
