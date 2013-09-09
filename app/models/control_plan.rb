class ControlPlan < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :plan_active, :plan_created_id, :plan_description, :plan_name, 
  :plan_notes, :plan_updated_id, :attachment_attributes

  after_initialize :default_values

  def default_values
    self.plan_active = true if self.attributes.has_key?("plan_active") && self.plan_active.nil?
  end

  has_one :attachment, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :attachment, :allow_destroy => true

  def redirect_path
      control_plan_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.plan_name = self.attachment.attachment_name
  end

end
