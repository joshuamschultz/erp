class ItemAltName < ActiveRecord::Base
  attr_accessible :item_alt_active, :item_alt_created_id, :item_alt_description, 
  :item_alt_identifier, :item_alt_notes, :item_alt_updated_id, :item_id, :organization_id
  
  after_initialize :default_values

  def default_values
    self.item_alt_active = true if self.item_alt_active.nil?
  end

  belongs_to :item
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]

  validates :item_id, :uniqueness => {:scope => :organization_id, :message => "already exists for the customer!" }

  # validates_uniqueness_of :item_alt_identifier
  validates_presence_of :item, :organization
  validates_length_of :item_alt_identifier, :maximum => 50 if validates_presence_of :item_alt_identifier

  has_many :item_selected_names, :dependent => :destroy
  has_many :item_revisions, :through => :item_selected_names
  has_many :po_lines
  has_many :so_lines
  has_many :quote_lines
  has_many :quality_actions

  has_many :transferring_po_lines, :foreign_key => "alt_name_transfer_id", :class_name => "PoLine"
  has_many :inventory_adjustments, :dependent => :destroy

  def alt_item_name
      self.item_alt_identifier + (self.organization ? " (#{self.organization.organization_name})" : "")
  end

  def self.get_alt_names
    # alt_names = ItemAltName.where("organization_id is not NULL")
    alt_names = ItemAltName.all
    item_alt_names = []
    alt_names.each do |alt_item|
      if  alt_item.item.present? 
        if alt_item.item_alt_identifier != alt_item.item.item_part_no 
          item_alt_names << alt_item
        end
      end
    end
    item_alt_names
  end
end
