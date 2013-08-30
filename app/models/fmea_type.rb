class FmeaType < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :fmea_active, :fmea_created_id, :fmea_description, 
       :fmea_name, :fmea_notes, :fmea_updated_id,:attachment_attributes

  after_initialize :default_values

  def default_values
    self.fmea_active = true if self.fmea_active.nil?
  end

  has_one :attachment, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :attachment, :allow_destroy => true


  def redirect_path
      process_type_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.fmea_name = self.attachment.attachment_name
  end
  
end
