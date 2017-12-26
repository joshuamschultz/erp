# == Schema Information
#
# Table name: control_plans
#
#  id               :integer          not null, primary key
#  plan_name        :string(255)
#  plan_description :string(255)
#  plan_notes       :text(65535)
#  plan_active      :boolean
#  plan_created_id  :integer
#  plan_updated_id  :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ControlPlan < ActiveRecord::Base
  has_one :attachment, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :attachment, :allow_destroy => true

  after_initialize :default_values
  before_save :before_save_values

  def default_values
    self.plan_active = true if self.attributes.has_key?("plan_active") && self.plan_active.nil?
  end

  def before_save_values
      self.plan_name = self.attachment.attachment_name
  end

end
