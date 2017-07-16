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
  belongs_to :organization, -> {where organization_type_id: MasterType.find_by_type_value("vendor").id}
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :po_header

  attr_accessible :so_line_cost, :so_line_created_id, :so_line_freight, :so_line_price, :so_line_quantity,
  :so_line_status, :so_line_updated_id, :organization_id, :item_id, :so_header_id, :item_alt_name_id,
  :so_line_notes, :so_line_active, :vendor_quality_id, :customer_quality_id, :so_line_shipped, :so_line_sell,
  :so_line_vendor_po, :po_header_id, :po, :item_revision_id

  validates_presence_of :so_header, :item_alt_name, :so_line_cost, :so_line_quantity

  validates_numericality_of :so_line_cost, :so_line_sell

  validates_numericality_of :so_line_quantity, greater_than: 0

  has_one :po_line
  has_many :receivable_shipments, :dependent => :destroy
  has_many :so_shipments, :dependent => :destroy

  before_create :create_level_default

  def create_level_default
    self.so_line_status = "open"
  end
  before_save :update_item_total

  def update_item_total
    self.so_line_price = (self.so_line_sell.round(10) * self.so_line_quantity.round(10)) #+ self.so_line_freight.round(10)
    self.item = self.item_alt_name.item
    # self.item_revision = self.item_alt_name.item.current_revision
  end

  after_save :update_so_total
  after_destroy :update_so_total

  def update_so_total
    so_identifier = (self.so_header.so_identifier == "Unassigned") ? SoHeader.new_so_identifier(0) : self.so_header.so_identifier
    so_status_count = self.so_header.so_lines.where("so_line_status = ?", "open").count
    so_header_status = (so_status_count == 0) ? "closed" : "open"
    i= 2
    loop do
      i+=1
      so_header = SoHeader.where('so_identifier = ? && id != ?', so_identifier,self.so_header.id ).first
      break unless(so_header.present?)
      so_identifier = SoHeader.new_so_identifier(i)
    end
    self.so_header.update_attributes(so_identifier: so_identifier,so_status: so_header_status, so_total: self.so_header.so_lines.sum(:so_line_price))
    generate_pdf
  end

  def so_line_item_name
    self.item_alt_name.alt_item_name
  end

  def generate_pdf
    html = CommonActions.sales_report(self.so_header.id)+'<style>#blank_page{display: none;}.de{margin: 35px 0 0; min-height: 555px;}.sal_tab2 {height: 755px;} @page{size:21cm 29.7cm;margin: 10mm 5mm 2mm 10mm;}</style>'

    # if Rails.env == "production"
    #   # html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    # end
    kit = PDFKit.new(html, :page_size => 'A4', :margin_left=>"0.7in" )
    # Get an inline PDF
    pdf = kit.to_pdf
    p pdf
    # Save the PDF to a file
    path = Rails.root.to_s+"/public/sales_report"
    if File.directory? path
    path = path+"/"+self.so_header.so_identifier.to_s+".pdf"
    kit.to_file(path)
    else
    Dir.mkdir path
    path = path+"/"+self.so_header.so_identifier.to_s+".pdf"
    kit.to_file(path)
    end
  end

end

