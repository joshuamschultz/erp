class ItemAltName < ActiveRecord::Base
  attr_accessible :item_alt_active, :item_alt_created_id, :item_alt_description, 
  :item_alt_identifier, :item_alt_notes, :item_alt_updated_id, :item_id, :organization_id
  
  after_initialize :default_values

  def default_values
		self.item_alt_active = true if self.item_alt_active.nil?
  end

  belongs_to :item
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]

  # validates :item_id, :uniqueness => { :scope => :organization_id, :message => "already exists for the customer!" }
  # validates_uniqueness_of :item_alt_identifier

  validates_presence_of :item, :organization
  validates_length_of :item_alt_identifier, :maximum => 50 if validates_presence_of :item_alt_identifier

  has_many :item_selected_names, :dependent => :destroy
  has_many :item_revisions, :through => :item_selected_names
  has_many :po_lines
  has_many :so_lines
  has_many :quote_lines

  def alt_item_name
  		self.item_alt_identifier + (self.organization ? " (#{self.organization.organization_name})" : "")
  end

end
