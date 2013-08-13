class PoLine < ActiveRecord::Base
  belongs_to :po_header
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_line
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :item
  belongs_to :item_revision
  
  attr_accessible :po_line_active, :po_line_cost, :po_line_created_id, :po_line_customer_po, 
  :po_line_notes, :po_line_quantity, :po_line_status, :po_line_total, :po_line_updated_id,
  :po_header_id, :organization_id, :so_line_id, :vendor_quality_id, :customer_quality_id,
  :item_id, :item_revision_id

  validates_presence_of :po_header
  validates_presence_of :organization
  validates_presence_of :customer_quality
  validates_presence_of :item
  validates_numericality_of :po_line_cost if validates_presence_of :po_line_cost
  validates_numericality_of :po_line_quantity if validates_presence_of :po_line_quantity

  before_save :update_item_total
  after_save :update_po_total
  after_destroy :update_po_total

  before_create :create_level_default

  def create_level_default
    self.po_line_status = "open"
  end

  def update_item_total
      self.po_line_total = self.po_line_cost * self.po_line_quantity
  end

  def update_po_total
      self.po_header.update_attributes(:po_total => self.po_header.po_lines.sum(:po_line_total))
  end

end
