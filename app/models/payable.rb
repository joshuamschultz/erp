class Payable < ActiveRecord::Base
  belongs_to :organization
  belongs_to :po_header
  attr_accessible :payable_active, :payable_cost, :payable_created_id, :payable_description, 
  :payable_discount, :payable_due_date, :payable_identifier, :payable_invoice_date, 
  :payable_notes, :payable_status, :payable_to_id, :payable_total, :payable_updated_id,
  :organization_id, :po_header_id

  belongs_to :payable_to_address, :class_name => "Contact", :foreign_key => "payable_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  # validates_presence_of :organization, :po_header

  before_save :process_before_save

  def process_before_save
  		self.payable_total = self.payable_cost.to_f - self.payable_discount.to_f
  end

end
