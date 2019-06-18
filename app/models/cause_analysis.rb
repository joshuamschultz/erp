# == Schema Information
#
# Table name: cause_analyses
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  notes       :text(65535)
#  active      :boolean
#  created_id  :integer
#  updated_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CauseAnalysis < ActiveRecord::Base

  has_many :quality_actions
  has_one :attachment, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachment, allow_destroy: true

  before_save :before_save_values
  after_initialize :default_values
  
  def default_values
    self.active = true if self.attributes.has_key?("active") && self.active.nil?
  end

  def before_save_values
    self.name = self.attachment.attachment_name
  end

end
