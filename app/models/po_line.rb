# == Schema Information
#
# Table name: po_lines
#
#  id                    :integer          not null, primary key
#  po_header_id          :integer
#  organization_id       :integer
#  so_line_id            :integer
#  vendor_quality_id     :integer
#  customer_quality_id   :integer
#  item_id               :integer
#  item_revision_id      :integer
#  item_selected_name_id :integer
#  item_alt_name_id      :integer
#  po_line_customer_po   :string(255)
#  po_line_cost          :decimal(25, 10)  default(0.0)
#  po_line_quantity      :integer          default(0)
#  po_line_total         :decimal(25, 10)  default(0.0)
#  po_line_status        :string(255)
#  po_line_notes         :text(65535)
#  po_line_active        :boolean
#  po_line_created_id    :integer
#  po_line_updated_id    :integer
#  created_at            :datetime
#  updated_at            :datetime
#  po_line_shipped       :integer          default(0)
#  alt_name_transfer_id  :integer
#  po_line_sell          :decimal(25, 10)  default(0.0)
#  quality_lot_id        :integer
#  process_type_id       :integer
#

class PoLine < ActiveRecord::Base
  belongs_to :po_header
  belongs_to :organization, -> { where organization_type_id: MasterType.find_by_type_value("customer").id }
  belongs_to :so_line
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_selected_name
  belongs_to :item_alt_name
  belongs_to :item_transfer_name, :foreign_key => "alt_name_transfer_id", :class_name => "ItemAltName"

  has_many :quality_lots, :dependent => :destroy
  has_many :payable_shipments, :dependent => :destroy
  has_many :po_shipments, :dependent => :destroy
  has_one :quote_line
  has_many :checklists

  has_one :notification, :as => :notable, dependent: :destroy

  accepts_nested_attributes_for :notification, :allow_destroy => true

  validates_presence_of :item_alt_name_id
  validates_presence_of :po_header, :item_alt_name, :po_line_cost, :po_line_quantity, :customer_quality
  validates_numericality_of :po_line_cost
  validates_numericality_of :po_line_quantity, greater_than: 0
  validates_numericality_of :po_line_sell, :if => Proc.new { |o| o.po_header.present? && o.po_header.customer.present? }

  before_create :create_level_default
  before_save :update_item_total
  before_save :update_po_total
  before_save :process_before_save
  after_save :prcess_after_save
  after_destroy :update_po_total

  def create_level_default
    # Set PO to Open
    self.po_line_status = "open"
    # If PO is direct, the organization is the customer
    if self.po_header.po_is?("direct")
      self.organization = self.po_header.customer
      self.po_line_customer_po = self.po_header.cusotmer_po
    end
  end

  def po_customer
    self.po_header.po_is?("direct") ? self.po_header.customer : self.organization
  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end

  def update_item_total
    self.po_line_total = self.po_line_cost * self.po_line_quantity
    self.item = self.item_alt_name.item
  end

  def update_po_total
    po_identifier = (self.po_header.po_identifier == UNASSIGNED) ? PoHeader.new_po_identifier(1) : self.po_header.po_identifier
    po_status_count = self.po_header.po_lines.where("po_line_status = ?", "open").count
    po_header_status = (po_status_count == 0) ? "closed" : "open"
    self.po_header.update_attributes(po_identifier: po_identifier, po_status: po_header_status, po_total: self.po_header.po_lines.sum(:po_line_total))
    generate_pdf
    #TODO: this slows down, need in background job - pdf generate
  end

  def process_before_save
    # If a direct PO setup sales order lines (and shipment lines)
    if self.po_header.po_is?("direct")
      so_line = self.so_line.present? ? self.so_line : SoLine.new
      so_line.update_attributes(so_header_id: self.po_header.so_header_id, item_alt_name_id: self.item_alt_name_id,
                                customer_quality_id: self.po_header.customer.customer_quality_id, so_line_cost: self.po_line_cost,
                                so_line_sell: self.po_line_sell, so_line_quantity: self.po_line_quantity, organization_id: self.po_header.organization_id)
      self.so_line_id = so_line.id
      # if transfer PO setup sales order lines (and shipment lines)
    elsif self.po_header.po_is?("transer")
      so_line = self.so_line.present? ? self.so_line : SoLine.new
      so_line.update_attributes(so_header_id: self.po_header.so_header_id, item_alt_name_id: self.item_transfer_name.id, so_line_cost: self.po_line_cost, so_line_quantity: self.po_line_quantity, organization_id: self.po_header.organization_id)
      self.po_header.so_header.update_attributes(organization_id: self.organization_id)
      self.so_line_id = so_line.id
    end
  end

  def prcess_after_save
    # Grabs variables and creates Purchase Order PDF
    # TODO make this happen on button click or email send, not on saving a line item
    po_identifier = (self.po_header.po_identifier == UNASSIGNED) ? PoHeader.new_po_identifier(0) : self.po_header.po_identifier
    po_status_count = self.po_header.po_lines.where("po_line_status = ?", "open").count
    po_header_status = (po_status_count == 0) ? "closed" : "open"
    i = 1
    loop do
      i += 1
      po_header = PoHeader.where("po_identifier = ? && id != ?", po_identifier, self.po_header.id).first
      break unless (po_header.present?)
      po_identifier = PoHeader.new_po_identifier(i)
    end
    self.po_header.update_attributes(po_identifier: po_identifier, po_status: po_header_status, po_total: self.po_header.po_lines.sum(:po_line_total))
    generate_pdf
  end

  def generate_pdf
    html = CommonActions.purchase_report(self.po_header.id) + "<style>#blank_page{display: none;} .art-01.art-04.art-07{  min-height: 445px;} .art-01.art-04{  min-height: 445px;} article.art-05{min-height: 137px;} article.art-01{min-height: 70px;} article.art-02{margin-top: 61px;height: 80px;} @page{size:21cm 29.7cm;margin: 12mm 5mm 2mm 10mm;}</style>"
    # if Rails.env == "production"
    #   # html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    # end
    kit = PDFKit.new(html, :page_size => "A4")
    # Get an inline PDF
    pdf = kit.to_pdf
    p pdf
    # Save the PDF to a file
    path = Rails.root.to_s + "/public/purchase_report"
    if File.directory? path
      path = path + "/" + self.po_header.po_identifier.to_s + ".pdf"
      kit.to_file(path)
    else
      Dir.mkdir path
      path = path + "/" + self.po_header.po_identifier.to_s + ".pdf"
      kit.to_file(path)
    end
  end
end
