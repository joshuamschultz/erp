# == Schema Information
#
# Table name: fmea_types
#
#  id               :integer          not null, primary key
#  fmea_name        :string(255)
#  fmea_description :string(255)
#  fmea_notes       :text(65535)
#  fmea_active      :boolean
#  fmea_created_id  :integer
#  fmea_updated_id  :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class FmeaType < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :fmea_active, :fmea_created_id, :fmea_description, 
       :fmea_name, :fmea_notes, :fmea_updated_id,:attachment_attributes

  after_initialize :default_values

  def default_values
    self.fmea_active = true if self.attributes.has_key?("fmea_active") && self.fmea_active.nil?
  end

  has_one :attachment, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :attachment, :allow_destroy => true


  def redirect_path
      fmea_type_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.fmea_name = self.attachment.attachment_name
  end
  
end
