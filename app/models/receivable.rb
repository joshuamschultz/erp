class Receivable < ActiveRecord::Base
  has_many :receivable_lines
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_header

  attr_accessible :receivable_active, :receivable_cost, :receivable_created_id,
  :receivable_discount, :receivable_identifier, :receivable_notes, :receivable_status, 
  :receivable_total, :receivable_updated_id, :so_header_id, :receivable_description, :organization_id

  validates_presence_of :receivable_description


  before_save :process_before_save

  def process_before_save
    self.receivable_identifier = "Receivable ##{self.id}"
  	self.receivable_total = self.update_receivable_total      
    return true
  end

  def update_receivable_total
      receivable_total = self.receivable_lines.sum(:receivable_line_cost) - self.receivable_discount
      receivable_total += self.so_header.so_total if self.so_header
      receivable_total
  end

  before_create :process_before_create

  def process_before_create
      self.receivable_identifier = "Receivable ##{self.id}"
      self.receivable_status = "open"
  end

end
