class Specification < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  after_initialize :default_values

  def default_values
    self.specification_active = true if self.specification_active.nil?
  end

  attr_accessible :specification_active, :specification_created_id, :specification_description, 
  :specification_identifier, :specification_notes, :specification_updated_id

  (validates_uniqueness_of :specification_identifier if validates_length_of :specification_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :specification_identifier

  validates_length_of :specification_description, :maximum => 50

  has_many :item_specifications, :dependent => :destroy
  has_many :item_revisions, :through => :item_specifications
  has_many :attachments, :as => :attachable, :dependent => :destroy

  def redirect_path
      specification_path(self)
  end
end
