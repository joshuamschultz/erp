class PoHeader < ActiveRecord::Base
  has_many :po_lines
  belongs_to :organization
  
  attr_accessible :po_active, :po_created_id, :po_description, :po_identifier, :po_notes, 
  :po_status, :po_total, :po_type_id, :po_updated_id, :organization_id

  belongs_to :po_type, :class_name => "MasterType", :foreign_key => "po_type_id", 
  	:conditions => ['type_category = ?', 'po_type']

  validates_presence_of :organization
  validates_presence_of :po_type

  # (validates_uniqueness_of :po_identifier if validates_length_of :po_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :po_identifier

  before_create :create_level_defaults

  def create_level_defaults
  		self.po_status = "open"
  end

end
