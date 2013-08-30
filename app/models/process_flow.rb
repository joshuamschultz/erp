class ProcessFlow < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :process_active, :process_created_id, :process_description, 
  :process_identifier, :process_name, :process_notes, :process_updated_id, :attachment_attributes

  after_initialize :default_values

  def default_values
    self.process_active = true if self.process_active.nil?
  end

  has_one :attachment, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :attachment, :allow_destroy => true

   def redirect_path
      process_flow_path(self)
  end


  before_save :before_save_values

  def before_save_values
      self.process_name = self.attachment.attachment_name
  end
  
end
