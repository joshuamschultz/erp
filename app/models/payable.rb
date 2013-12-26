class Payable < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]
  belongs_to :po_header  

  attr_accessible :payable_active, :payable_cost, :payable_created_id, :payable_description, 
  :payable_discount, :payable_due_date, :payable_identifier, :payable_invoice_date, 
  :payable_notes, :payable_status, :payable_to_id, :payable_total, :payable_updated_id,
  :organization_id, :po_header_id, :payable_freight, :po_shipments_attributes, :payable_invoice

  belongs_to :payable_to_address, :class_name => "Contact", :foreign_key => "payable_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  has_many :payable_lines, :dependent => :destroy
  has_many :payment_lines, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy

  has_many :payable_po_shipments, :dependent => :destroy
  has_many :po_shipments, through: :payable_po_shipments

  accepts_nested_attributes_for :po_shipments

  validates_presence_of :payable_invoice_date, :payable_due_date, :organization #, :po_header, :payable_identifier
  validates_presence_of :payable_invoice, on: :update

  # validates_presence_of :payable_identifier, :if => Proc.new { |o| o.po_header.nil? }
  # validates_uniqueness_of :payable_identifier

  before_save :process_before_save

  def process_before_save
      self.organization = self.po_header.organization if self.po_header
  		# self.payable_total = self.update_payable_total
  end

  after_save :process_after_save

  def process_after_save
      self.process_payable_total
  end 

  before_create :process_before_create

  def process_before_create
      # self.payable_identifier =  "Invoice #{Payable.all.count + 1}"

      max_identifier = Payable.maximum(:payable_identifier)
      if max_identifier.nil?
          self.payable_identifier = "A0001"
      elsif (cur_identifier = max_identifier[1..5].to_i + 1) > 9999
          self.payable_identifier = max_identifier[0].next + "0001"
      else
          self.payable_identifier = max_identifier[0] + "%04d" % cur_identifier
      end

      self.payable_status = "open"     
  end  

  def process_payable_total
      Payable.skip_callback("save", :before, :process_before_save)
      Payable.skip_callback("save", :after, :process_after_save)
      self.payable_total = self.update_payable_total
      self.save(validate: false)
      # self.update_attributes(:payable_total => payable_total)
      Payable.set_callback("save", :before, :process_before_save)
      Payable.set_callback("save", :after, :process_after_save)
  end

  def update_payable_total
      payable_total = self.payable_lines.sum(:payable_line_cost) - self.payable_discount      
      payable_total += self.po_shipments.sum(:po_shipped_cost) if self.po_header
      payable_total
  end

  def payable_current_balance
      self.payable_total - self.payment_lines.sum(:payment_line_amount)
  end

  def redirect_path
      payable_path(self)
  end

end
