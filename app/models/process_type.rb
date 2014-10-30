class ProcessType < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :process_active, :process_created_id, :process_description, 
  :process_notes, :process_short_name, :process_updated_id, :attachment_attributes

  after_initialize :default_values

  def default_values
    self.process_active = true if self.process_active.nil?
  end

  # (validates_uniqueness_of :process_short_name if validates_length_of :process_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :process_short_name

  # validates_length_of :process_description, :maximum => 50

  has_many :organization_processes, :dependent => :destroy
  has_many :organizations, :through => :organization_processes
  has_many :item_processes, :dependent => :destroy
  has_many :item_revisions, :through => :item_processes
  has_one :attachment, :as => :attachable, :dependent => :destroy

  default_scope :order => 'process_short_name ASC'
  accepts_nested_attributes_for :attachment, :allow_destroy => true

  def redirect_path
      process_type_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.process_short_name = self.attachment.attachment_name
  end
  
end
