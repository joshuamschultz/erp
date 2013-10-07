class QuoteLine < ActiveRecord::Base
  belongs_to :quote
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  
  attr_accessible :quote_line_active, :quote_line_cost, :quote_line_created_id, :quote_line_identifier, 
  :quote_line_notes, :quote_line_quantity, :quote_line_status, :quote_line_total, :quote_line_updated_id,
  :quote_id, :item_id, :item_revision_id, :item_alt_name_id

  validates_numericality_of :quote_line_quantity
  validates_presence_of :quote, :item_alt_name
  validates :item_alt_name_id, :uniqueness => { :scope => :quote_id, :message => "duplicate item entry!" }

  before_create :create_level_default
  before_save :process_before_create


  def create_level_default
    self.quote_line_status = "open"
    # self.quote_line_identifier
  end

  def process_before_create
    self.item = self.item_alt_name.item
    self.item_revision = self.item_alt_name.item.current_revision
  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end
  
end
