class ItemAltName < ActiveRecord::Base
  attr_accessible :item_alt_active, :item_alt_created_id, :item_alt_description, 
  :item_alt_identifier, :item_alt_notes, :item_alt_updated_id
  
  after_initialize :default_values

  def default_values
    self.item_alt_active = true if self.item_alt_active.nil?
  end

  (validates_uniqueness_of :item_alt_identifier if validates_length_of :item_alt_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :item_alt_identifier

  has_many :item_selected_names, :dependent => :destroy
  has_many :item_revisions, :through => :item_selected_names
end
