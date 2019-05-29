# == Schema Information
#
# Table name: so_lines
#
#  id                  :integer          not null, primary key
#  so_header_id        :integer
#  item_id             :integer
#  item_revision_id    :integer
#  item_alt_name_id    :integer
#  organization_id     :integer
#  vendor_quality_id   :integer
#  customer_quality_id :integer
#  so_line_cost        :decimal(25, 10)  default(0.0)
#  so_line_price       :decimal(25, 10)  default(0.0)
#  so_line_quantity    :integer          default(0)
#  so_line_freight     :decimal(25, 10)  default(0.0)
#  so_line_status      :string(255)
#  so_line_notes       :text(65535)
#  so_line_active      :boolean
#  so_line_created_id  :integer
#  so_line_updated_id  :integer
#  created_at          :datetime
#  updated_at          :datetime
#  so_line_shipped     :integer          default(0)
#  so_line_sell        :decimal(25, 10)  default(0.0)
#  so_line_vendor_po   :string(255)
#  po_header_id        :integer
#  po                  :string(255)
#

class SoLine < ActiveRecord::Base
  belongs_to :so_header
  belongs_to :organization, -> { where organization_type_id: MasterType.find_by_type_value("vendor").id }
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :po_header

  has_one :po_line

  has_many :receivable_shipments, dependent: :destroy
  has_many :so_shipments, dependent: :destroy

  validates_presence_of :so_header, :item_alt_name, :so_line_cost, :so_line_quantity
  validates_numericality_of :so_line_cost, :so_line_sell
  validates_numericality_of :so_line_quantity, greater_than: 0

  before_create :create_level_default
  before_validation :set_item
  before_validation :update_item_total
  after_save :update_so
  after_destroy :update_so

  def create_level_default
    self.so_line_status = "open"
  end

  def update_item_total
    self.so_line_price = so_line_sell * so_line_quantity
  end

  def set_item
    self.item = item_alt_name.item
  end

  def update_so
    # until the SO has an item, it should be unassigned. So we check and assign here
    set_so_identifier if so_header.so_identifier == "Unassigned"
    close_sales_order
    so_header.update_attributes(so_total: so_header.so_lines.sum(:so_line_price))
    #generate_pdf
  end

  def close_sales_order
    #TODO: this should be moved to receiving, not sure why here.
    so_status_count = so_header.so_lines.where("so_line_status = ?", "open").count
    so_header_status = "closed" if so_status_count == 0
    so_header.update_attributes(so_status: so_header_status)
  end

  def set_so_identifier
    so_header.update_attributes(so_identifier: SoHeader.new_so_identifier(0))
  end

  def so_line_item_name
    self.item_alt_name.alt_item_name
  end

  def generate_pdf
    html = CommonActions.sales_report(self.so_header.id) + "<style>#blank_page{display: none;}.de{margin: 35px 0 0; min-height: 555px;}.sal_tab2 {height: 755px;} @page{size:21cm 29.7cm;margin: 10mm 5mm 2mm 10mm;}</style>"

    # if Rails.env == "production"
    #   # html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    # end
    kit = PDFKit.new(html, :page_size => "A4", :margin_left => "0.7in")
    # Get an inline PDF
    pdf = kit.to_pdf
    p pdf
    # Save the PDF to a file
    path = Rails.root.to_s + "/public/sales_report"
    if File.directory? path
      path = path + "/" + self.so_header.so_identifier.to_s + ".pdf"
      kit.to_file(path)
    else
      Dir.mkdir path
      path = path + "/" + self.so_header.so_identifier.to_s + ".pdf"
      kit.to_file(path)
    end
  end
end
