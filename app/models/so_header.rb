class SoHeader < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
	attr_accessible :so_bill_to_id, :so_cofc, :so_comments, :so_identifier, :so_notes, :so_due_date, 
	:so_ship_to_id, :so_squality, :so_status, :so_total, :organization_id, :so_header_customer_po
  
  validates_presence_of :organization
  
  belongs_to :organization
  belongs_to :bill_to_address, :class_name => "Contact", :foreign_key => "so_bill_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  belongs_to :ship_to_address, :class_name => "Contact", :foreign_key => "so_ship_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  has_one :po_header
	has_many :attachments, :as => :attachable, :dependent => :destroy  
	has_many :comments, :as => :commentable, :dependent => :destroy
	has_many :so_lines, :dependent => :destroy
  has_many :receivables, :dependent => :destroy

  default_scope order('created_at DESC')
	before_create :before_create_level_defaults


  def before_create_level_defaults
  		self.so_status = "open"
      self.so_identifier = "Unassigned"

    	# self.so_identifier = Time.now.strftime("%m%y") + ("%03d" % (SoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
    	# self.so_identifier.slice!(2)
      # self.so_identifier = "S" + self.so_identifier
  end

  def redirect_path
      so_header_path(self)
  end

  scope :status_based_sos, lambda{|status| where(:so_status => status) }

  def self.new_so_identifier
      so_identifier = Time.now.strftime("%m%y") + ("%03d" % (SoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
      so_identifier.slice!(2)
      "S" + so_identifier
  end


  def self.process_receivable_so_lines(params)
      so_shipment = SoShipment.find_by_id(params[:shipments][0]) if params[:shipments].present? && params[:shipments].any?
      so_header = so_shipment.so_line.so_header if so_shipment && so_shipment.so_line
      if so_header
          receivable = so_header.receivables.build
          receivable.receivable_invoice = "Invoice"
          receivable.organization = so_header.organization
          params[:shipments].each{|shipment_id| 
              so_shipment = SoShipment.find_by_id(shipment_id);
              receivable.so_shipments << so_shipment if so_shipment && so_shipment.so_line && so_shipment.so_line.so_header == so_header
          }
          receivable
      else
          Receivable.new
      end
  end


  
end
