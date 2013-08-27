class SoLine < ActiveRecord::Base
  belongs_to :so_header
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name

  attr_accessible :so_line_cost, :so_line_created_id, :so_line_freight, :so_line_price, :so_line_quantity, 
  :so_line_status, :so_line_updated_id, :organization_id, :item_id, :so_header_id, :item_alt_name_id,
  :so_line_notes, :so_line_active

  validates_presence_of :so_header, :organization, :item_alt_name, :so_line_cost, :so_line_quantity

  validates_numericality_of :so_line_cost, :so_line_quantity

  before_create :create_level_default

  def create_level_default
    	self.so_line_status = "open"
  end

  before_save :update_item_total

  def update_item_total
      self.so_line_price = (self.so_line_cost.round(10) * self.so_line_quantity.round(10)) #+ self.so_line_freight.round(10)
      self.item = self.item_alt_name.item
      self.item_revision = self.item_alt_name.item.current_revision
  end

  after_save :update_so_total
  after_destroy :update_so_total

  def update_so_total
      self.so_header.update_attributes(:so_total => self.so_header.so_lines.sum(:so_line_price))
  end


end
