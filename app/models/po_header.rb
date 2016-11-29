class PoHeader < ActiveRecord::Base 
  include Rails.application.routes.url_helpers

  attr_accessible :po_active, :po_created_id, :po_description, :po_identifier, :po_notes, 
  :po_status, :po_total, :po_type_id, :po_updated_id, :organization_id, :customer_id,
  :po_bill_to_id, :po_ship_to_id, :cusotmer_po, :so_header_id

  validates_presence_of :organization
  validates_presence_of :po_type

  validates_presence_of :customer, :if => Proc.new { |o| o.po_is?("direct") }
  validates_presence_of :cusotmer_po, :if => Proc.new { |o| o.po_is?("direct") }

  # (validates_uniqueness_of :po_identifier if validates_length_of :po_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :po_identifier

  before_create :before_create_level_defaults

  def before_create_level_defaults
    self.po_status = "open"
    self.po_identifier = UNASSIGNED

    # self.po_identifier = Time.now.strftime("%m%y") + ("%03d" % (PoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
    # self.po_identifier.slice!(2)
    # self.po_identifier = "P" + self.po_identifier
  end

  before_save :process_before_save

  def process_before_save
      if self.po_is?("direct")
          self.po_lines.update_all(organization_id: self.customer_id, po_line_customer_po: self.cusotmer_po)
          so_header = self.so_header.present? ? self.so_header : SoHeader.new
          so_header.update_attributes(organization_id: self.customer_id, so_bill_to_id: self.po_bill_to_id, so_ship_to_id: self.po_ship_to_id, so_header_customer_po: self.cusotmer_po, so_due_date: Time.now)
          self.so_header_id = so_header.id
          so_header.so_lines.update_all(organization_id: self.organization_id)
      elsif self.po_is?("transer")
          # self.po_lines.update_all(organization_id: self.customer_id, po_line_customer_po: self.cusotmer_po)
          so_header = self.so_header.present? ? self.so_header : SoHeader.new
          so_header.update_attributes(organization_id: 1, so_due_date: Time.now)
          self.so_header_id = so_header.id
          # so_header.so_lines.update_all(organization_id: self.organization_id)
      end
  end

  belongs_to :so_header

  belongs_to :organization, -> {where organization_type_id: MasterType.find_by_type_value("vendor").id }

  belongs_to :customer, -> {where organization_type_id: MasterType.find_by_type_value("customer").id },
                        :foreign_key => "customer_id", :class_name => "Organization"  

  belongs_to :bill_to_address, ->{where('contactable_type = ? and contact_type = ?', 'Organization', 'address')},
                               :class_name => "Contact", :foreign_key => "po_bill_to_id" 

  belongs_to :ship_to_address, ->{where('contactable_type = ? and contact_type = ?', 'Organization', 'address')},
                               :class_name => "Contact", :foreign_key => "po_ship_to_id" 
  belongs_to :po_type, -> {where type_category: po_type },
                       :class_name => "MasterType", :foreign_key => "po_type_id" 

  has_many :po_lines, :dependent => :destroy
  has_many :quality_lots, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :payables, :dependent => :destroy
  has_many :quotes
  has_many :quotes, :through => :quotes_po_headers
  has_many :quotes_po_headers

  def redirect_path
    po_header_path(self)
  end

  # default_scope order('created_at DESC')


  scope :status_based_pos, lambda{|status| where(:po_status => status) }

  def self.new_po_identifier(i)
      po_identifier = Time.now.strftime("%m%y") + ("%03d" % (PoHeader.where("month(created_at) = ?", Date.today.month).count + i))
      po_identifier.slice!(2)
      "P" + po_identifier
  end

  def self.process_payable_po_lines(params)
      po_shipment = PoShipment.find_by_id(params[:shipments][0]) if params[:shipments].present? && params[:shipments].any?
      po_header = po_shipment.po_line.po_header if po_shipment && po_shipment.po_line
      if po_header
          payable = po_header.payables.build
          payable.organization = po_header.organization
          payable.payable_invoice = "Invoice"
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

  def po_is?(po_type)
      self.po_type.present? && self.po_type_value == po_type
  end
  def po_report
    CommonActions.purchase_report(self.id).html_safe
  end

end
