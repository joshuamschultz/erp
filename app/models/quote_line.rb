class QuoteLine < ActiveRecord::Base
  belongs_to :quote
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  belongs_to :po_line
  # belongs_to :organization

  has_many :quote_line_costs, :dependent => :destroy
  
  attr_accessible :quote_line_active, :quote_line_cost, :quote_line_created_id, :quote_line_identifier, 
  :quote_line_notes, :quote_line_quantity, :quote_line_status, :quote_line_total, :quote_line_updated_id,
  :quote_id, :item_id, :item_revision_id, :item_alt_name_id, :po_line_id, :organization_id, 
  :quote_line_description

  validates_numericality_of :quote_line_quantity
  validates_presence_of :quote, :item_alt_name, :quote_line_quantity
  validates :item_alt_name_id, :uniqueness => { :scope => :quote_id, :message => "duplicate item entry!" }

  # validate :check_quote_line
  # def check_quote_line
  #     errors.add(:item_id, "can add only after vendors selected!") unless self.quote.quote_vendors.any?
  # end

  before_create :process_before_create

  def process_before_create
    self.quote_line_active = false
    self.quote_line_status = "open"
    self.item = self.item_alt_name.item
    self.item_revision = self.item_alt_name.item.current_revision
  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end

  after_destroy :process_after_destroy

  def process_after_destroy
      # self.po_line.destroy
      self.update_quote_total
  end

  before_save :process_before_save

  def process_before_save
      self.quote_line_total = self.quote_line_cost * self.quote_line_quantity
  end

  after_save :process_after_save

  def process_after_save
      self.update_quote_total
  end

  def update_quote_total
      Quote.skip_callback("save", :before, :process_before_save)
      self.quote.update_attributes(:quote_total => self.quote.quote_lines.sum(:quote_line_total))
      Quote.set_callback("save", :before, :process_before_save)
  end

end
