class PoHeader < ActiveRecord::Base 
  include Rails.application.routes.url_helpers

  attr_accessible :po_active, :po_created_id, :po_description, :po_identifier, :po_notes, 
  :po_status, :po_total, :po_type_id, :po_updated_id, :organization_id, :customer_id,
  :po_bill_to_id, :po_ship_to_id, :cusotmer_po, :so_header_id

  validates_presence_of :organization
  validates_presence_of :po_type

  validates_presence_of :customer, :if => Proc.new { |o| o.po_type.present? && o.po_type.type_value == "direct" }
  validates_presence_of :cusotmer_po, :if => Proc.new { |o| o.po_type.present? && o.po_type.type_value == "direct" }

  # (validates_uniqueness_of :po_identifier if validates_length_of :po_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :po_identifier

  before_create :before_create_level_defaults

  def before_create_level_defaults
		self.po_status = "open"
    self.po_identifier = "Unassigned"

    # self.po_identifier = Time.now.strftime("%m%y") + ("%03d" % (PoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
    # self.po_identifier.slice!(2)
    # self.po_identifier = "P" + self.po_identifier
  end

  before_save :process_before_save

  def process_before_save
      if (self.po_type_value == "direct")          
          self.po_lines.update_all(organization_id: self.customer_id)
          so_header = self.so_header.present? ? self.so_header : SoHeader.new
          so_header.update_attributes(organization_id: self.customer_id, so_bill_to_id: self.po_bill_to_id, so_ship_to_id: self.po_ship_to_id, so_header_customer_po: self.cusotmer_po)
          self.so_header_id = so_header.id
      end
  end

  belongs_to :so_header

  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]

  belongs_to :customer, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id], 
        :foreign_key => "customer_id", :class_name => "Organization"

  belongs_to :bill_to_address, :class_name => "Contact", :foreign_key => "po_bill_to_id", 
  :conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  belongs_to :ship_to_address, :class_name => "Contact", :foreign_key => "po_ship_to_id", 
  :conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  belongs_to :po_type, :class_name => "MasterType", :foreign_key => "po_type_id", 
  	:conditions => ['type_category = ?', 'po_type']

  has_many :po_lines, :dependent => :destroy
  has_many :quality_lots, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :payables, :dependent => :destroy
  has_many :quotes

  def redirect_path
    po_header_path(self)
  end

  scope :status_based_pos, lambda{|status| where(:po_status => status) }

  def self.new_po_identifier
      po_identifier = Time.now.strftime("%m%y") + ("%03d" % (PoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
      po_identifier.slice!(2)
      "P" + po_identifier
  end

  def self.process_payable_po_lines(params)
      po_shipment = PoShipment.find_by_id(params[:shipments][0]) if params[:shipments].present? && params[:shipments].any?
      po_header = po_shipment.po_line.po_header if po_shipment && po_shipment.po_line
      if po_header
          payable = po_header.payables.build
          payable.payable_identifier = "Invoice"
          payable.payable_invoice_date = Date.today
          payable.payable_due_date = Date.today
          params[:shipments].each{|shipment_id| 
              po_shipment = PoShipment.find_by_id(shipment_id);
              payable.po_shipments << po_shipment if po_shipment && po_shipment.po_line && po_shipment.po_line.po_header == po_header
          }
          payable
      else
          Payable.new
      end
  end

  def po_type_value
      self.po_type.type_value
  end


end
