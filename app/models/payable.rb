class Payable < ActiveRecord::Base
  has_many :payable_lines
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]
  belongs_to :po_header

  attr_accessible :payable_active, :payable_cost, :payable_created_id, :payable_description, 
  :payable_discount, :payable_due_date, :payable_identifier, :payable_invoice_date, 
  :payable_notes, :payable_status, :payable_to_id, :payable_total, :payable_updated_id,
  :organization_id, :po_header_id

  belongs_to :payable_to_address, :class_name => "Contact", :foreign_key => "payable_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  has_many :payable_lines, :dependent => :destroy
  has_many :payment_lines, :dependent => :destroy

  validates_presence_of :payable_invoice_date, :payable_due_date, :payable_description

  before_save :process_before_save

  def process_before_save
      self.payable_identifier = "Payable ##{self.id}"
  		self.payable_total = self.update_payable_total      
      return true
  end

  def update_payable_total
      payable_total = self.payable_lines.sum(:payable_line_cost) - self.payable_discount
      payable_total += self.po_header.po_total if self.po_header
      payable_total
  end

  before_create :process_before_create

  def process_before_create
      self.payable_identifier = "Payable ##{self.id}"
      self.payable_status = "open"
  end

end
