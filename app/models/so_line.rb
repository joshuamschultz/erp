class SoLine < ActiveRecord::Base
  belongs_to :so_header
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  belongs_to :vendor_quality
  belongs_to :customer_quality  

  attr_accessible :so_line_cost, :so_line_created_id, :so_line_freight, :so_line_price, :so_line_quantity, 
  :so_line_status, :so_line_updated_id, :organization_id, :item_id, :so_header_id, :item_alt_name_id,
  :so_line_notes, :so_line_active, :vendor_quality_id, :customer_quality_id, :so_line_shipped, :so_line_sell,
  :so_line_vendor_po

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
      self.item_revision = self.item_alt_name.item.current_revision
  end

  after_save :update_so_total
  after_destroy :update_so_total

  def update_so_total
      so_identifier = (self.so_header.so_identifier == "Unassigned") ? SoHeader.new_so_identifier : self.so_header.so_identifier
      self.so_header.update_attributes(so_identifier: so_identifier, so_total: self.so_header.so_lines.sum(:so_line_price))
      generate_pdf
  end

  def so_line_item_name
      self.item_alt_name.alt_item_name
  end
  def generate_pdf
  
    @company_info = CompanyInfo.first 
    b_c_title = b_c_address_1 = b_c_address_2 = b_c_state = b_c_country = b_c_zipcode =''
    s_c_title = s_c_address_1 = s_c_address_2 = s_c_state = s_c_country = s_c_zipcode = ''
    item_part_no = item_alt_name = po_identifier = organization_name = item_description = ''
    so_line_quantity = so_line_shipped = 0

    @so_header = self.so_header

    if @so_header.bill_to_address.present?
      b_c_title = @so_header.bill_to_address.contact_title 
      b_c_address_1 = @so_header.bill_to_address.contact_address_1 
      b_c_address_2= @so_header.bill_to_address.contact_address_2
      b_c_state = @so_header.bill_to_address.contact_state 
      b_c_country = @so_header.bill_to_address.contact_country 
      b_c_zipcode = @so_header.bill_to_address.contact_zipcode 
    end

    if @so_header.ship_to_address.present?
      s_c_title = @so_header.ship_to_address.contact_title
      s_c_address_1= @so_header.ship_to_address.contact_address_1 
      s_c_address_2 = @so_header.ship_to_address.contact_address_2 
      s_c_state = @so_header.ship_to_address.contact_state 
      s_c_country = @so_header.ship_to_address.contact_country 
      s_c_zipcode = @so_header.ship_to_address.contact_zipcode 
      end

      if @so_header.po_header.present? 
        po_identifier = @so_header.po_header.po_identifier 
      end 

      @so_header.so_lines.each do |so_line|

        so_line_quantity = so_line.so_line_quantity

        so_line_shipped = so_line.so_line_shipped

        if so_line.item_revision.present?
          item_description = so_line.item_revision.item_description
        end
                                                  
        # if so_line.organization.present? 
        #   organization_name = so_line.organization.organization_name
        # end 

        if so_line.item.item_part_no == so_line.item_alt_name.item_alt_identifier 
          item_part_no = so_line.item.item_part_no 
        else 
          item_part_no = so_line.item.item_part_no
          item_alt_name = so_line.item_alt_name.item_alt_identifier
        end 

      end 

  html = %'<!DOCTYPE html><title>Sales Report</title><style type="text/css">@charset "utf-8";body {font-family: Arial, Helvetica, sans-serif;font-size: 14px;}/* New Style */.clear {clear: both;}.ms_wrapper {height: auto;}.ms_wrapper section {float: left;height: auto;width: 640px;}.ms_wrapper .ms_heading {border-bottom: 2px solid #999;font-size: 16px;margin: 30px 0 4px;padding: 0 0 10px;        width: 100%;    }    .ms_wrapper .ms_image {        border: 1px solid #ccc;        float: left;        font-size: 22px;        text-align: center;        width: 310px;        height: 85px;        padding: 25px 0 ;    }    .ms_wrapper .ms_image-2 {        border: 1px solid #ccc;        float: right;        font-size: 22px;        text-align: center;        width: 310px;        height: 135px;    }    .ms_wrapper article {float: left;width: 100%;}}.ms_wrapper .ms_text {    float: left;    font-size: 15px;    height: auto;    line-height: 23px;    width: 262px;    margin: 0;    color: #666;}.ms_wrapper .ms_offers {    float: left;    margin: 12px 0 0;    padding: 10px 0 0;    text-align: center;}.ms_wrapper .ms_sub-heading {    font-size: 22px;margin: 20px 0 6px;    color: #000;}.ms_text strong,.ms_text-2 strong {    float: left;    font-size: 14px;    font-weight: normal;    line-height: 19px;    width: 100%;}.ms_text1 strong {float: left;    font-size: 14px;    font-weight: normal;    line-height: 19px;    width: 100%;    margin: 1px 0;    text-align: center;font-weight: bold;}.ms_image-2 h3 {    color: #000080;    font-size: 16px;    font-weight: normal;    margin: 17px 0 0;    text-decoration: underline;}.ms_image-2 h2 {    color: #800000;font-size: 20px;font-weight: bold;margin: 2px 0;}.ms_image-2 h5 {font-size: 16px;font-weight: bold; margin: 2px 0;}.ms_text-3-wrapper {float: left;width: 310px;}.ms_text-3-wrapper .ms_text-3 {width: 152px;float: left;}.ms_text-3-wrapper .ms_text-4 {width: 152px;float: right;}.ms_text-3-wrapper .ms_text-4 strong {float: left;font-size: 14px;font-weight: normal;line-height: 19px;width: 100%;margin: 6px 0;text-align: center;}.ms_text-3-wrapper .ms_text-3 strong {color: #800000;float: left;font-size: 14px;font-weight: normal;line-height: 19px;width: 100%;margin: 6px 0;text-align: center;}.ms_text-3.text-5 strong {color: #000 !important;}.ms_text-3-wrapper .ms_sub-heading {font-size: 16px;text-align: center;margin: 30px 0 12px;}.ms_sub {font-size: 15px;text-align: center;text-decoration: underline;margin: 2px 0 10px 0;}.ms_text {border-bottom: 2px solid #999;float: left;padding: 0 0 16px;width: 310px;}.ms_text-2 {border-bottom: 2px solid #999;float: right;padding: 0 0 16px;width: 310px;}.ms_text1 {float: left;margin: 12px 28px 0;width: 42%;}.ms_wrapper .ms_image2 {margin: 0 20px 0 0;border: 1px solid #ccc;padding: 20px 0;text-align: center;font-size: 22px;}.ms_image2 h2 {font-size: 17px;margin: 0;}.ms_image2 strong {color: #800000;float: left;font-size: 22px;margin: 0 0 8px;width: 100%;}.ms_image2 p {font-size: 18px;margin: 0;color: #000080;}.footer {margin: 330px 0 0 0;width: 630px;border: 2px solid #444;float: left;}.page {float: left;margin: 0 0 0 20px;}.page h3 {font-size: 14px;font-weight: bold;margin: 12px 0 0;}.page h4 {font-size: 12px;font-weight: normal;margin: 5px 0 12px 0;text-align: center;}.original {float: right;margin: 0 20px 0 0;}.original h3 {font-size: 14px;font-weight: bold;margin: 12px 0 0;}.original h4 {color: #800000;font-size: 12px;font-weight: normal;margin: 5px 0 12px 0;text-align: center;}.original h4 span{color: #000;}.original h4 span {color: #000;margin: 0 4px 0 0;}.page-center {float: left;text-align: center;width: 411px;}.page-center h3 {color: #800000;font-size: 14px;font-weight: bold;margin: 12px 0 0;}.page-center h4 {font-size: 12px;font-weight: normal;margin: 5px 0 12px 0;text-align: center;}.text-6 {color: #800000;margin: 0 14px 0 0 !important;width: auto !important;}.text-7 {float: left;margin: 22px 0 0;width: 100%;} .ms_image img {width: 196px;}</style><div class="ms_wrapper"><section><article><div class="ms_image"><img alt=Report_heading src=http://erp.chessgroupinc.com/#{@company_info.logo.joint.url(:original)} /></div><div class="ms_image-2"><h3> Sales Order Number </h3><h2> #{ @so_header.so_identifier } </h2><h5>Sales Order Date : #{ @so_header.created_at.strftime("%m/%d/%Y") } </h5><h5> Customer P.O:#{ @so_header.so_header_customer_po }</h5></div></article><article><div class="ms_text"><h1 class="ms_heading">Bill To :</h1> <h2 class="ms_sub-heading">#{ b_c_title }</h2> <strong>#{ b_c_address_1 }</strong> <strong>#{ b_c_address_2 }</strong><strong>#{ b_c_state }</strong><strong>#{ b_c_country }&nbsp;#{ b_c_zipcode }</strong></div><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1>     <h2 class="ms_sub-heading">#{ s_c_title } </h2> <strong>#{ s_c_address_1 }</strong> <strong>#{ s_c_address_2 }</strong><strong>#{ s_c_state }  </strong><strong>#{ s_c_country }&nbsp;#{ s_c_zipcode } </strong>                </div></article><article><div class="ms_text-3-wrapper"><div class="ms_text-3 text-5"><h2 class="ms_sub-heading">CUST P/N - ALL P/N</h2>      <strong> '+item_part_no+'</strong><strong> '+item_alt_name+'</strong>    </div><div class="ms_text-4"><h2 class="ms_sub-heading"> Description </h2> <strong> '+item_description +' </strong>   <div class="text-7"><strong class="text-6" > '+ organization_name+' </strong></div><div class="text-7"><strong class="text-6"> '+po_identifier+'  </strong></div> </div></div><div class="ms_text-3-wrapper"><div class="ms_text-3"><h2 class="ms_sub-heading">QTY</h2> <strong> '+so_line_quantity.to_s+'  </strong></div><div class="ms_text-4"><h2 class="ms_sub-heading">  Shipped </h2> <strong> '+so_line_shipped.to_s+'  </strong></div></div></article><article><div class="footer"><div class="page"><h3>Page </h3><h4>1</h4></div><div class="page-center">  <h3> '+@so_header.so_notes+'</h3></div><div class="original"><h3>Original </h3><h4><span>$</span> '+@so_header.so_total.to_s+'  </h4></div></article></div></div>'
 


    # if Rails.env == "production"
    #   # html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    # end
    kit = PDFKit.new(html, :page_size => 'A4' )  
    # Get an inline PDF
    pdf = kit.to_pdf
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
