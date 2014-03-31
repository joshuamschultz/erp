class Specification < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  after_initialize :default_values

  def default_values
    self.specification_active = true if self.specification_active.nil?
  end

  attr_accessible :specification_active, :specification_created_id, :specification_description, 
  :specification_identifier, :specification_notes, :specification_updated_id, :attachment_attributes

  # (validates_uniqueness_of :specification_identifier if validates_length_of :specification_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :specification_identifier

  # validates_length_of :specification_description, :maximum => 50

  has_many :item_specifications, :dependent => :destroy
  has_many :item_revisions, :through => :item_specifications
  has_one :attachment, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :attachment, :allow_destroy => true

  def redirect_path
      specification_path(self)
  end

  before_save :before_save_values

  def before_save_values
      self.specification_identifier = self.attachment.attachment_name
  end
  
end
