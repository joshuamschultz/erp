class Print < ActiveRecord::Base
  attr_accessible :print_active, :print_created_id, :print_description, :print_identifier, 
  :print_notes, :print_updated_id
  
  has_many :item_prints, :dependent => :destroy
  has_many :item_revisions, :through => :item_prints

  after_initialize :default_values

  def default_values
    	self.print_active = true if self.print_active.nil?
  end

  validates_length_of :print_identifier, :minimum => 2, :maximum => 50 if validates_presence_of :print_identifier

end
