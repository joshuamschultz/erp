# == Schema Information
#
# Table name: process_flows
#
#  id                  :integer          not null, primary key
#  process_identifier  :string(255)
#  process_name        :string(255)
#  process_description :string(255)
#  process_notes       :text(65535)
#  process_active      :boolean
#  process_created_id  :integer
#  process_updated_id  :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class ProcessFlow < ActiveRecord::Base
  has_one :attachment, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :attachment, :allow_destroy => true

  before_save :before_save_values

  def default_values
    self.process_active = true if self.attributes.has_key?("process_active") && self.process_active.nil?
  end

  def before_save_values
    self.process_name = self.attachment.attachment_name
  end

end
