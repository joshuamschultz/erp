class PoLine < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :po_header
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_line
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_selected_name
  belongs_to :item_alt_name

  attr_accessible :po_line_active, :po_line_cost, :po_line_created_id, :po_line_customer_po, 
  :po_line_notes, :po_line_quantity, :po_line_status, :po_line_total, :po_line_updated_id,
  :po_header_id, :organization_id, :so_line_id, :vendor_quality_id, :customer_quality_id,
  :item_id, :item_revision_id, :item_selected_name_id, :item_alt_name_id, :po_line_shipped,
  :alt_name_transfer_id, :po_line_sell, :notification_attributes

  has_many :quality_lots, :dependent => :destroy
  has_many :payable_shipments, :dependent => :destroy
  has_many :po_shipments, :dependent => :destroy
  has_one :quote_line
  has_many :checklists

  has_one :notification, :as => :notable,  dependent: :destroy

  accepts_nested_attributes_for :notification, :allow_destroy => true

  belongs_to :item_transfer_name, :foreign_key => "alt_name_transfer_id", :class_name => "ItemAltName"

  validates_presence_of :item_alt_name_id
  validates_presence_of :po_header, :item_alt_name, :po_line_cost, :po_line_quantity, :customer_quality
  validates_numericality_of :po_line_cost

  validates_numericality_of :po_line_quantity, greater_than: 0

  validates_numericality_of :po_line_sell, :if => Proc.new { |o| o.po_header.present? && o.po_header.customer.present? }

  before_create :create_level_default

  def create_level_default
    self.po_line_status = "open"
    if self.po_header.po_is?("direct")
        self.organization = self.po_header.customer
        self.po_line_customer_po = self.po_header.cusotmer_po
    end
  end




  before_save :update_item_total

  def update_item_total
    self.po_line_total = self.po_line_cost * self.po_line_quantity
    self.item = self.item_alt_name.item
    self.item_revision = self.item_alt_name.item.current_revision
  end

  after_save :update_po_total
  after_destroy :update_po_total

  def update_po_total
    po_identifier = (self.po_header.po_identifier == UNASSIGNED) ? PoHeader.new_po_identifier : self.po_header.po_identifier
    po_status_count = self.po_header.po_lines.where("po_line_status = ?", "open").count
    po_header_status = (po_status_count == 0) ? "closed" : "open"
    self.po_header.update_attributes(po_identifier: po_identifier,po_status: po_header_status, po_total: self.po_header.po_lines.sum(:po_line_total))
    generate_pdf
  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end

  def po_line_data_list(object, shipment)
    po_line = shipment ? object.po_line : object
     if User.current_user.present? &&  !User.current_user.is_operations? && !User.current_user.is_clerical?
      object[:po_identifier] = CommonActions.linkable(po_header_path(po_line.po_header), po_line.po_header.po_identifier)
      object[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
      object[:vendor_name] = (CommonActions.linkable(organization_path(po_line.po_header.organization), po_line.po_header.organization.organization_name) if po_line.po_header.organization) || ""
      object[:customer_name] = (CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) if po_line.organization) || "" 
      object[:quality_id_name] = (CommonActions.linkable(customer_quality_path(po_line.po_header.organization.vendor_quality), po_line.po_header.organization.vendor_quality.quality_name) if po_line.po_header.organization && po_line.po_header.organization.vendor_quality) || ""
       object[:quality_level_name] = (CommonActions.linkable(customer_quality_path(po_line.customer_quality), po_line.customer_quality.quality_name) if po_line.organization ) || CommonActions.linkable(customer_quality_path(CustomerQuality.first), CustomerQuality.first.quality_name)
      object[:po_line_quantity] = po_line.po_line_quantity      
      object[:po_line_quantity_shipped] = "<div class='po_line_shipping_total'>#{po_line.po_line_shipped}</div>"
      object[:po_line_quantity_open] = "<div class='po_line_quantity_open'>#{po_line.po_line_quantity - po_line.po_line_shipped}</div>"
      unless shipment
        object[:po_line_shipping] = "<div class='po_line_shipping_input'><input po_line_id='#{po_line.id}' po_shipped_status='received' class='shipping_input_field shipping_input_po_#{po_line.po_header.id}' type='text' value='0'></div>"
        object[:po_line_shelf] = "<div class='po_line_shelf_input'><input type='text'></div>"
        object[:po_line_unit] =  "<div class='po_line_unit_input'><input type='text'></div>"
        object[:po_identifier] += "<a onclick='process_all_open(#{po_line.po_header.id}, $(this)); return false' class='pull-right btn btn-small btn-success' href='#'>Receive All</a>"
        object[:po_identifier] += "<a onclick='fill_po_items(#{po_line.po_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Fill</a>"
        
        object[:links] = "<a po_line_id='#{po_line.id}' po_shipped_status='rejected' class='pull-right btn_save_shipped btn-action glyphicons ban btn-danger' href='#'><i></i></a> "
        object[:links] += " <a po_line_id='#{po_line.id}' po_shipped_status='on hold' class='pull-right btn_save_shipped btn-action glyphicons circle_exclamation_mark btn-warning' href='#'><i></i></a> "
        object[:links] += " <a po_line_id='#{po_line.id}' po_shipped_status='received' class='pull-right btn_save_shipped btn-action glyphicons check btn-success' href='#'><i></i></a> "
        object[:links] += " <div class='pull-right shipping_status'></div>"
      end
       object
    else
      object[:po_identifier] = CommonActions.linkable(po_header_path(po_line.po_header), po_line.po_header.po_identifier)
      object[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
      object[:vendor_name] = (CommonActions.linkable(organization_path(po_line.po_header.organization), po_line.po_header.organization.organization_name) if po_line.po_header.organization) || ""
      object[:customer_name] = (CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) if po_line.organization) || "" 
      object[:quality_id_name] = (CommonActions.linkable(customer_quality_path(po_line.po_header.organization.vendor_quality), po_line.po_header.organization.vendor_quality.quality_name) if po_line.po_header.organization && po_line.po_header.organization.vendor_quality) || ""
        object[:quality_level_name] = (CommonActions.linkable(customer_quality_path(po_line.customer_quality), po_line.customer_quality.quality_name) if po_line.organization ) || CommonActions.linkable(customer_quality_path(CustomerQuality.first), CustomerQuality.first.quality_name)
      object[:po_line_quantity] = po_line.po_line_quantity      
      object[:po_line_quantity_shipped] = "<div class='po_line_shipping_total'>#{po_line.po_line_shipped}</div>"
      object[:po_line_quantity_open] = "<div class='po_line_quantity_open'>#{po_line.po_line_quantity - po_line.po_line_shipped}</div>"
   
      unless shipment
        object[:po_line_shipping] = ""
        object[:po_line_shelf] = ""
        object[:po_line_unit] =  ""
        object[:po_identifier] += ""
        object[:po_identifier] += ""
       
        
        object[:links] = ""
        object[:links] += ""
        object[:links] += ""
        object[:links] += ""
      end
  
    object
  end
end

  before_save :process_before_save

  def process_before_save
      if self.po_header.po_is?("direct")
          so_line = self.so_line.present? ? self.so_line : SoLine.new
          so_line.update_attributes(so_header_id: self.po_header.so_header_id, item_alt_name_id: self.item_alt_name_id, 
            customer_quality_id: self.po_header.customer.customer_quality_id, so_line_cost: self.po_line_cost, 
            so_line_sell: self.po_line_sell, so_line_quantity: self.po_line_quantity, organization_id: self.po_header.organization_id)
          self.so_line_id = so_line.id
          
      # elsif self.po_header.po_is?("transer")
      #     so_line = self.so_line.present? ? self.so_line : SoLine.new
      #     so_line.update_attributes(so_header_id: self.po_header.so_header_id, item_alt_name_id: self.item_transfer_name.id, 
      #       customer_quality_id: 25, so_line_cost: self.po_line_cost, 
      #       so_line_sell: 1, so_line_quantity: self.po_line_quantity, organization_id: self.po_header.organization_id)
      #     self.so_line_id = so_line.id
      end

  end


  def po_customer
      self.po_header.po_is?("direct") ? self.po_header.customer : self.organization
  end


  def generate_pdf

  @company_info = CompanyInfo.first

 product1 = product2 = product_description =po_line_comment  = product_notes = source =''      
  self.po_header.po_lines.each do |po_line| 
    if po_line.item.item_part_no == po_line.item_alt_name.item_alt_identifier 
      product1= "<tr><td width='150' scope='row'>" +(po_line.item.item_part_no).to_s+"</td></tr>"
    else 
      product1="<tr><td width='150' scope='row'>" +(po_line.item.item_part_no).to_s+"</td></tr>"
      product2= "<tr><td width='150' scope='row'>"+(po_line.item_alt_name.item_alt_identifier).to_s+ "</td></tr>"
    end 
    if po_line.item_revision.present?
      product_description= ""+po_line.item_revision.item_description.to_s+""
      product_notes= po_line.item_revision.item_notes.to_s
      po_line_comment = po_line.po_line_notes
    else
      product_description = '&nbsp'
    end

    source+="


 <div class='ff'>
    <table cellspacing='0' cellpadding='0' width='678px' border='0'>
        <tbody>

    <tr valign='top' align='left' class='h-pad'>


      <td width='72'>" +po_line.po_line_quantity.to_s+"</td>
      <td>


        <table width='100%'' border='0'><tbody>"+product1+""+product2+"</tbody></table>



      </td>

 <td>"+product_description+"</td>

      <td>"+(po_line.po_line_cost.to_f).to_s+"</td>
      <td>"+(po_line.po_line_total.to_f).to_s+"</td>

    </tr>         </tbody>
        </table>


            <div class='sd'>
                <div class='sd1'>
        <table cellspacing='0' cellpadding='0' border='0' width='100%'' border-collapse='collapse'>
          <tbody>
    
            <tr>
              <td>"+product_notes+"</td>
            </tr>    
            <tr>
              <td>"+po_line_comment+"</td>
            </tr>
         </tbody>
        </table>
</div></div></div></div>"

         
  end 

  html = %'<!DOCTYPE html>
<html>
<head>
<title>Member Spotlight</title>
<!--[if lt IE 9]><script src="html5.js"></script><![endif]-->


<style>
@charset "utf-8";

body{ font-family:Arial,Helvetica,sans-serif;font-size:14px;}


/* New Style */
.clear{clear: both;}

.ms_wrapper{height: auto;}
.ms_wrapper section {
   float: left;
   height: auto;
   width: 678px;
}
.ms_wrapper .ms_heading {  text-decoration: underline; font-size: 14px;margin: 17px 0 4px; padding: 0 0 10px;float: left;}

.ms_wrapper .ms_image {
    border: 1px solid #ccc;
    float: left;
    font-size: 22px;
    height: 104px;
    text-align: center;
    width: 310px;
}
.ms_wrapper .ms_heading-3{  text-decoration: underline; font-size: 14px;margin: 0 0 4px; padding: 0 0 10px;float: left;}

article.art-01 {
    border-bottom: 1px solid #555;
    border-top: 1px solid #555;
    margin: 18px 0 0;
    padding: 7px 0 0;
}

 .ms_wrapper .ms_image-2 {
    border: 1px solid #ccc;
    float: right;
    font-size: 22px;
    height: 104px;
    text-align: center;}
.ms_wrapper article{float: left;width: 100%;}
}
.ms_wrapper .ms_text {float: left;font-size: 15px;height: auto;line-height: 23px; width: 262px; margin: 0;color:#666;}
.ms_wrapper .ms_offers { float: left; margin: 12px 0 0; padding: 10px 0 0; text-align: center;}
.ms_wrapper .ms_sub-heading{font-size: 13px;margin:20px 0 6px;color:#000;}

.ms_text strong, .ms_text-2 strong {
    float: left;
    font-size: 13px;
    font-weight: normal;
    line-height: 19px;
    width: 100%;
}
.ms_text1 strong {
    float: left;
    font-size: 14px;
    font-weight: normal;
    line-height: 19px;
    width: 100%;
    margin: 1px 0;
    text-align: center;
    font-weight: bold;
}
.ms_text-6.ms-33 .ms_sub-heading {
    font-size: 17px;
}

.ms_text-6.ms-33 {
    text-align: center;
}
.ms_image-2 h3 {
    color: #000080;
    font-size: 21px;
    font-weight: normal;
    margin: 17px 0 0;
    text-decoration: underline;
}


.ms_text-6 > h3 {
    float: left;
    font-size: 12px;
    margin: 0;
    padding: 0;
}


.ms_text-6 {
    float: left;
    margin: 0 0 0 27px;
    width: 212px;
}

.ms_image-2 h2 {
    color: #800000;
    font-size: 20px;
    font-weight: bold;
    margin: 2px 0;
}

        .ms_image-2 h5{  font-size: 16px;
    font-weight: bold;margin: 2px 0;}

.ms_text-3-wrapper {
    float: left;

}
.ms_text-3-wrapper .ms_text-3{width: 126px;float: left;}
.ms_text-3-wrapper .ms_text-5{width: 204px;float: left;text-align: center;}
.ms_text-3-wrapper .ms_text-4 {
    float: left;
    width: 91px;
}

article.art-02 {
    border: 1px solid #555;
    border-radius: 15px;
    margin: 150px 0 0;
    padding: 7px 0 0;
}
.ms_text-5 > strong {
    font-weight: normal;
}

.ms_text-3-wrapper .ms_text-4 strong {
    float: left;
    font-size: 14px;
    font-weight: normal;
    line-height: 19px;
    width: 100%;
    margin: 6px 0;
    text-align: center;

}

.ms_text-3-wrapper .ms_text-3 strong {
    float: left;
    font-size: 14px;
    font-weight: normal;
    line-height: 19px;
    width: 100%;
    margin: 6px 0;
    text-align: center;

}


.ms_text-3-wrapper .ms_sub-heading {
    border-bottom: 1px solid #555;
    font-size: 13px;
    margin: 21px 0 12px;
    padding: 0 0 12px;
    text-align: center;
}

.ms_sub{  font-size: 15px;
    text-align: center;
    text-decoration: underline;
margin: 2px 0 10px 0;}


.ms_text {
    border-right: 1px solid #555;
    float: left;
    padding: 0 3px 11px;
    width: 310px;
}
.ms_text-2 {
    float: right;
    padding: 0 0 16px;
     min-height: 35px;
}

.ms_text-7 > strong {
    float: none;
}
.ms_text-7.ms_text-8 {
    border-bottom: 1px solid #555;
    padding: 0 0 9px;
}

.ms-1 {
    float: left !important;
    text-align: right;
    width: 95px !important;
}
.ms_text-7.ms_text-9 strong {
    font-size: 14px;
    font-weight: bold;
}
.ms_text-7 {
    float: left;
    margin: 4px 0;
    width: 90%;
}
.ms_text1 {
    float: left;
    margin: 12px 28px 0;
    width: 42%;
}

.ms-5{color: #800000;}
.ms-2 {
    margin: 0 0 0 38px;
}


.ms_text-55 {
   float: left;
   padding: 0 3px 11px;
}
.ms_wrapper .ms_image2{margin: 0 20px 0 0;border: 1px solid #ccc;padding: 20px 0;text-align: center;font-size: 22px;}
.ms_image2 h2{font-size: 17px;margin: 0;}
.ms_image2 strong {
    color: #800000;
    float: left;
    font-size: 22px;
    margin: 0 0 8px;
    width: 100%;
}
.ms_image2 p{font-size: 18px;margin: 0;color: #000080;}

.footer {
    border: 2px solid #444;
    float: left;
    margin: 11px 0 0;
    width: 678px;
}.page{float: left;margin: 0 0 0 20px;}
.page h3{font-size: 14px; font-weight: bold;   margin: 12px 0 0;}
.page h4{font-size: 12px; font-weight: normal;margin: 5px 0 12px 0;text-align: center;}
.original{float: right;margin: 0 20px 0 0;}
.original h3{font-size: 14px; font-weight: bold;   margin: 12px 0 0;}
.original h4{font-size: 12px; font-weight: normal;margin: 5px 0 12px 0;text-align: center;}

.ms_image-wrapper {
    float: left;
    height: 69px;
    margin: 6px 0 0 3px;
    width: 128px;
}
.ms_image-wrapper img {
    width: 150px;
}

.ms_image-text {
    float: right;
    margin: 6px 10px 0 0;
}
.ms_image-text h2 {
    font-size: 13px;
    margin: 19px 0 8px 0;
     text-decoration: underline;
}
.ms_image-text h3 {
    border-bottom: 1px solid #555;
    font-size: 13px;
    font-weight: normal;
    margin: 12px 0 6px 0;
    padding: 0 0 7px;
}



.ms_image-text h5 {
    font-size: 9px;
    font-weight: normal;
}


.page-center {
    float: left;
    margin: 8px 36px;
    width: 394px;
}
 .ms_text-5 strong {
   float: left;
   margin: 6px 0;
   width: 100%;
}

.page-center h3{font-size: 14px; font-weight: bold;   margin: 12px 0 0;}
.page-center h4 {
    font-size: 9px;
    font-weight: normal;
    margin: 0 0 12px;
    text-align: center;
}




.hea.art-002 {
border-bottom: 1px solid #222;
float: left;
font-weight: bold;
width: 100%;
}
.hea.art-002 > td {
padding: 0;
width: 134px;
    border: 1px solid;
}


.h-pad > td {
    padding: 9px 12px;
    text-align: center;
    width: 109px;
    border: 1px solid #000;
}
.h-pad {
    width: 100%;
}


.h-pad-04{width: 640px;text-align: center;}

.h-pad-04 {
    color: #800000;
    text-align: left;
    width: 128px;
}

.sd1 {
    text-align: center;
    width: 100%;
}

.sd1 td {
    border: 1px solid #000;
    color: #800000;
}
</style>
</head><body><div class="ms_wrapper"><section><article><div class="ms_image"><div class="ms_image-wrapper"><img alt=Report_heading src=http://erp.chessgroupinc.com/#{@company_info.logo.joint.url(:original)} /></div><div class="ms_image-text"><h5>#{@company_info.company_address1}<br/>#{@company_info.company_address2}<hr><b>P:&nbsp;</b> #{@company_info.company_phone1}<br/>&nbsp;<b>F:&nbsp;</b> #{@company_info.company_fax}<hr></h5></div></div><div class="ms_image-2"><h3> Purchase Order Number</h3><h2> #{self.po_header.po_identifier}</h2><h5>Purchase Order Date :  #{self.po_header.created_at.strftime("%m/%d/%Y")} </h5></div></article><article class="art-01"><div class="ms_text"><h1 class="ms_heading">Vendor :</h1> <div class="ms_text-6"><h2 class="ms_sub-heading">#{self.po_header.organization.organization_name}<br>#{self.po_header.organization.organization_address_1}#{self.po_header.organization.organization_address_2}</h2> <h3> #{self.po_header.organization.organization_city}#{self.po_header.organization.organization_state} #{self.po_header.organization.organization_country}#{self.po_header.organization.organization_zipcode}</h3></div></div><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1> <div class="ms_text-6 ms-33"><h2 class="ms_sub-heading">Chess Group Inc </h2> <strong>#{@company_info.company_address1}</strong><strong>#{@company_info.company_address2}</strong></div></div></article><article>






<article class="art-01 art-04"><table cellspacing="0" cellpadding="0" width="678px" border="0"><tbody><tr align="center" class="hea art-002"><td>QTY</td><td>CUST P/N-ALL P/N</td><td>DESCRIPTION</td><td>COST</td><td>TOTAL</td></tr></tbody></table>#{source}</tbody>




</table></article>







</article><article class="art-02"><div class="ms_text-55"><h1 class="ms_heading-3">Comments:</h1> <div class="ms_text-6">                <strong class="ms-5">#{self.po_header.po_notes}</strong> </div></div><div class="ms_text-2"><div class="ms_text-6"><div class="ms_text-7 ms_text-8 "></div><div class="ms_text-7 ms_text-9 "> <strong class="ms-1">P.O. Total :</strong>  <strong class="ms-2"> #{self.po_header.po_total.to_f}</strong> </div></div></div></article><article><div class="footer"><div class="page"><h3>Date</h3><h4>#{self.po_header.created_at.strftime("%m/%d/%Y")}</h4></div><div class="page-center"><h4>Audit Right Reserved - The Buyer, the Customer, the Government,the FAA and / or any other Page regulatory agencies reserve the right to audit Seller"s books and records and the right to inspect at the Seller"s plant any and all materials and systems.</h4></div><div class="original"><h3>Page </h3><h4>1</h4></div></article></div></div></body></html>'

 


    # if Rails.env == "production"
    #   # html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    # end
    kit = PDFKit.new(html, :page_size => 'A4' )  
    # Get an inline PDF
    pdf = kit.to_pdf
    # Save the PDF to a file    
    path = Rails.root.to_s+"/public/purchase_report"
    if File.directory? path
    path = path+"/"+self.po_header.po_identifier.to_s+".pdf"
    kit.to_file(path)
    else
    Dir.mkdir path
    path = path+"/"+self.po_header.po_identifier.to_s+".pdf"
    kit.to_file(path)
    end
  end

end
