class Print < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :print_active, :print_created_id, :print_description, :print_identifier, 
  :print_notes, :print_updated_id, :attachment_attributes
  
  # has_one :item_print, :dependent => :destroy
  # has_one :item_revision, :through => :item_print
  has_many :item_revisions
  has_one :attachment, :as => :attachable, :dependent => :destroy

  after_initialize :default_values

  accepts_nested_attributes_for :attachment, :allow_destroy => true

  def default_values
    	self.print_active = true if self.attributes.has_key?("print_active") && self.print_active.nil?
  end

  # validates_length_of :print_identifier, :minimum => 2, :maximum => 50 if validates_presence_of :print_identifier

  def redirect_path
      print_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.print_identifier = self.attachment.attachment_name
  end

end
