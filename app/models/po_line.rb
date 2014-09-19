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
  :alt_name_transfer_id, :po_line_sell

  has_many :quality_lots, :dependent => :destroy
  has_many :payable_shipments, :dependent => :destroy
  has_many :po_shipments, :dependent => :destroy
  has_one :quote_line
  has_many :checklists

  belongs_to :item_transfer_name, :foreign_key => "alt_name_transfer_id", :class_name => "ItemAltName"

  validates_presence_of :item_alt_name_id
  validates_presence_of :po_header, :item_alt_name, :po_line_cost, :po_line_quantity
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

    self.po_header.update_attributes(po_identifier: po_identifier, po_total: self.po_header.po_lines.sum(:po_line_total))
    generate_pdf
  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end

  def po_line_data_list(object, shipment)
    po_line = shipment ? object.po_line : object
    object[:po_identifier] = CommonActions.linkable(po_header_path(po_line.po_header), po_line.po_header.po_identifier)
    object[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
    object[:vendor_name] = (CommonActions.linkable(organization_path(po_line.po_header.organization), po_line.po_header.organization.organization_name) if po_line.po_header.organization) || ""
    object[:customer_name] = (CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) if po_line.organization) || ""
    object[:quality_level_name] = (CommonActions.linkable(customer_quality_path(po_line.organization.customer_quality), po_line.organization.customer_quality.quality_name) if po_line.organization && po_line.organization.customer_quality) || ""
    object[:quality_id_name] = (CommonActions.linkable(customer_quality_path(po_line.po_header.organization.vendor_quality), po_line.po_header.organization.vendor_quality.quality_name) if po_line.po_header.organization && po_line.po_header.organization.vendor_quality) || ""
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
  end

  before_save :process_before_save

  def process_before_save
      if self.po_header.po_is?("direct")
          so_line = self.so_line.present? ? self.so_line : SoLine.new
          so_line.update_attributes(so_header_id: self.po_header.so_header_id, item_alt_name_id: self.item_alt_name_id, 
            customer_quality_id: self.po_header.customer.customer_quality_id, so_line_cost: self.po_line_cost, 
            so_line_sell: self.po_line_sell, so_line_quantity: self.po_line_quantity, organization_id: self.po_header.organization_id)
          self.so_line_id = so_line.id
      end
  end


  def po_customer
      self.po_header.po_is?("direct") ? self.po_header.customer : self.organization
  end


  def generate_pdf

    @company_info = CompanyInfo.first

        a = []
        b = []
        c1 = []
        c2 = []
        qty = []




                   
                             self.po_header.po_lines.each do |po_line| 
                              qty<< "<strong>"+po_line.po_line_quantity.to_s+"</strong>"

                              if po_line.item.item_part_no == po_line.item_alt_name.item_alt_identifier 
                                c1<< "<strong>"+(po_line.item.item_part_no).to_s+"</strong>"
                              else 
                                c1<< "<strong>"+(po_line.item.item_part_no).to_s+"</strong>"
                                c2<< "<strong>"+(po_line.item_alt_name.item_alt_identifier).to_s+"</strong>"
                              end 
                              if po_line.item_revision.present?
                                b<< "<strong>"+(po_line.item_revision.item_description).to_s+ "</strong>"
                              end 

                                a<< "<strong>"+(po_line.po_line_cost.to_f).to_s+"</strong>"
                            end 

                               temp = a.to_s
                               temp = temp.gsub( /\[/, '')      
                               temp = temp.gsub( /\]/, '')                          
                               temp = temp.gsub( /\,/, '')                          
                               a = temp.gsub( /\"/, '')  

                              temp = b.to_s
                               temp = temp.gsub( /\[/, '')      
                               temp = temp.gsub( /\]/, '')                          
                               temp = temp.gsub( /\,/, '')                          
                               b = temp.gsub( /\"/, '')  


                              temp = c1.to_s
                               temp = temp.gsub( /\[/, '')      
                               temp = temp.gsub( /\]/, '')                          
                               temp = temp.gsub( /\,/, '')                          
                               c1 = temp.gsub( /\"/, '')  
                              temp = c2.to_s
                               temp = temp.gsub( /\[/, '')      
                               temp = temp.gsub( /\]/, '')                          
                               temp = temp.gsub( /\,/, '')                          
                               c2 = temp.gsub( /\"/, '')  

                                temp = qty.to_s
                               temp = temp.gsub( /\[/, '')      
                               temp = temp.gsub( /\]/, '')                          
                               temp = temp.gsub( /\,/, '')                          
                               qty = temp.gsub( /\"/, '')  


    html = "<!DOCTYPE html>\n<html>\n<head>\n<title>Member Spotlight</title>\n<!--[if lt IE 9]><script src=\"html5.js\"></script><![endif]-->\n\n\n<style>\n@charset \"utf-8\";\n\nbody{ font-family:Arial,Helvetica,sans-serif;font-size:14px;}\n\n\n/* New Style */\n.clear{clear: both;}\n\n.ms_wrapper{height: auto;}\n.ms_wrapper section {float: left;height: auto;width:640px;}\n.ms_wrapper .ms_heading {  text-decoration: underline; font-size: 14px;margin: 17px 0 4px; padding: 0 0 10px;float: left;}\n.ms_wrapper .ms_image{   border: 1px solid #ccc;\n    float: left;\n    font-size: 22px;\n    text-align: center;\n    width: 310px;\nheight: 135px;\n}\n.ms_wrapper .ms_heading-3{  text-decoration: underline; font-size: 14px;margin: 0 0 4px; padding: 0 0 10px;float: left;}\n\narticle.art-01 {\n    border-bottom: 1px solid #555;\n    border-top: 1px solid #555;\n    margin: 18px 0 0;\n    padding: 7px 0 0;\n}\n\n    .ms_wrapper .ms_image-2{   border: 1px solid #ccc;\n    float: right;\n    font-size: 22px;\n    text-align: center;\n    width: 310px;\nheight: 135px;}\n.ms_wrapper article{float: left;width: 100%;}\n}\n.ms_wrapper .ms_text {float: left;font-size: 15px;height: auto;line-height: 23px; width: 262px; margin: 0;color:#666;}\n.ms_wrapper .ms_offers { float: left; margin: 12px 0 0; padding: 10px 0 0; text-align: center;}\n.ms_wrapper .ms_sub-heading{font-size: 13px;margin:20px 0 6px;color:#000;}\n\n.ms_text strong, .ms_text-2 strong {\n    float: left;\n    font-size: 13px;\n    font-weight: normal;\n    line-height: 19px;\n    width: 100%;\n}\n.ms_text1 strong {\n    float: left;\n    font-size: 14px;\n    font-weight: normal;\n    line-height: 19px;\n    width: 100%;\n    margin: 1px 0;\n    text-align: center;\n    font-weight: bold;\n}\n.ms_text-6.ms-33 .ms_sub-heading {\n    font-size: 17px;\n}\n\n.ms_text-6.ms-33 {\n    text-align: center;\n}\n.ms_image-2 h3 {\n    color: #000080;\n    font-size: 21px;\n    font-weight: normal;\n    margin: 17px 0 0;\n    text-decoration: underline;\n}\n\n.ms_text-6 > h3 {\n    float: left;\n    margin: 0;\n    padding: 18px 0 0;\n    font-size: 14px;\n}\n\n\n.ms_text-6 {\n    float: left;\n    margin: 0 0 0 27px;\n    width: 212px;\n}\n\n.ms_image-2 h2 {\n    color: #800000;\n    font-size: 20px;\n    font-weight: bold;\n    margin: 2px 0;\n}\n\n        .ms_image-2 h5{  font-size: 16px;\n    font-weight: bold;margin: 2px 0;}\n\n.ms_text-3-wrapper {\n    float: left;\n\n}\n.ms_text-3-wrapper .ms_text-3{width: 126px;float: left;}\n.ms_text-3-wrapper .ms_text-5{width: 204px;float: left;text-align: center;}\n.ms_text-3-wrapper .ms_text-4 {\n    float: left;\n    width: 91px;\n}\n\narticle.art-02 {\n    border: 1px solid #555;\n    margin: 18px 0 0;\n    padding: 7px 0 0;\n    border: 1px solid #555;\n    border-radius: 15px;\n}\n.ms_text-5 > strong {\n    font-weight: normal;\n}\n\n.ms_text-3-wrapper .ms_text-4 strong {\n    float: left;\n    font-size: 14px;\n    font-weight: normal;\n    line-height: 19px;\n    width: 100%;\n    margin: 6px 0;\n    text-align: center;\n\n}\n\n.ms_text-3-wrapper .ms_text-3 strong {\n    float: left;\n    font-size: 14px;\n    font-weight: normal;\n    line-height: 19px;\n    width: 100%;\n    margin: 6px 0;\n    text-align: center;\n\n}\n\n\n.ms_text-3-wrapper .ms_sub-heading {\n    border-bottom: 1px solid #555;\n    font-size: 13px;\n    margin: 21px 0 12px;\n    padding: 0 0 12px;\n    text-align: center;\n}\n\n.ms_sub{  font-size: 15px;\n    text-align: center;\n    text-decoration: underline;\nmargin: 2px 0 10px 0;}\n\n\n.ms_text {\n    border-right: 1px solid #555;\n    float: left;\n    padding: 0 3px 11px;\n    width: 310px;\n}\n.ms_text-2 {\n    float: right;\n    padding: 0 0 16px;\n     min-height: 128px;\n}\n\n.ms_text-7 > strong {\n    float: none;\n}\n.ms_text-7.ms_text-8 {\n    border-bottom: 1px solid #555;\n    padding: 0 0 9px;\n}\n\n.ms-1 {\n    float: left !important;\n    text-align: right;\n    width: 95px !important;\n}\n.ms_text-7.ms_text-9 strong {\n    font-size: 14px;\n    font-weight: bold;\n}\n.ms_text-7 {\n    float: left;\n    margin: 4px 0;\n    width: 90%;\n}\n.ms_text1 {\n    float: left;\n    margin: 12px 28px 0;\n    width: 42%;\n}\n\n.ms-5{color: #800000;}\n.ms-2 {\n    margin: 0 0 0 38px;\n}\n\n\n.ms_text-55 {\n   float: left;\n   padding: 0 3px 11px;\n}\n.ms_wrapper .ms_image2{margin: 0 20px 0 0;border: 1px solid #ccc;padding: 20px 0;text-align: center;font-size: 22px;}\n.ms_image2 h2{font-size: 17px;margin: 0;}\n.ms_image2 strong {\n    color: #800000;\n    float: left;\n    font-size: 22px;\n    margin: 0 0 8px;\n    width: 100%;\n}\n.ms_image2 p{font-size: 18px;margin: 0;color: #000080;}\n.footer{margin:200px 0 0 0;width:640px;border: 2px solid #444;float: left; }\n.page{float: left;margin: 0 0 0 20px;}\n.page h3{font-size: 14px; font-weight: bold;   margin: 12px 0 0;}\n.page h4{font-size: 12px; font-weight: normal;margin: 5px 0 12px 0;text-align: center;}\n.original{float: right;margin: 0 20px 0 0;}\n.original h3{font-size: 14px; font-weight: bold;   margin: 12px 0 0;}\n.original h4{font-size: 12px; font-weight: normal;margin: 5px 0 12px 0;text-align: center;}\n\n.ms_image-wrapper {\n    float: left;\n    height: 69px;\n    margin: 6px 0 0 3px;\n    width: 128px;\n}\n.ms_image-wrapper img {\n    width: 150px;\n}\n\n.ms_image-text {\n    float: right;\n    margin: 6px 10px 0 0;\n}\n.ms_image-text h2 {\n    font-size: 13px;\n    margin: 19px 0 8px 0;\n     text-decoration: underline;\n}\n.ms_image-text h3 {\n    border-bottom: 1px solid #555;\n    font-size: 13px;\n    font-weight: normal;\n    margin: 12px 0 6px 0;\n    padding: 0 0 7px;\n}\n\n\n\n.ms_image-text h5 {\n    font-size: 9px;\n    font-weight: normal;\n}\n\n\n.page-center {\n    float: left;\n    margin: 8px 36px;\n    width: 394px;\n}\n.page-center h3{font-size: 14px; font-weight: bold;   margin: 12px 0 0;}\n.page-center h4{font-size: 12px; font-weight: normal;margin: 5px 0 12px 0;text-align: center;}\n</style>\n</head>\n<body>\n<div class=\"ms_wrapper\">\n\n    <section>\n\n        <article>\n            <div class=\"ms_image\">\n                <div class=\"ms_image-wrapper\">\n                    <img alt=\"Report_heading\" src=\"#{@company_info.logo.joint.url(:original)}\" />\n                </div>\n\n                <div class=\"ms_image-text\">\n                    <h5>#{@company_info.company_address1}<br/>\n                    #{@company_info.company_address2}\n                    <hr>\n                    <b>P:&nbsp;</b>#{@company_info.company_phone1}<br/>\n                    &nbsp;<b>F:&nbsp;</b>#{@company_info.company_fax}\n                    <hr></h5>\n                </div>\n            </div>\n\n            <div class=\"ms_image-2\">\n                <h3> Purchase Order Number</h3>\n                <h2>#{self.po_header.po_identifier}</h2>\n                <h5>Purchase Order Date :  #{self.po_header.created_at.strftime("%m/%d/%Y")} </h5>\n            </div>\n\n        </article>\n\n        <article class=\"art-01\">\n\n            <div class=\"ms_text\">\n                <h1 class=\"ms_heading\">Vendor :</h1> \n                <div class=\"ms_text-6\">\n                    <h2 class=\"ms_sub-heading\">\n                        #{self.po_header.organization.id}<br>\n                        #{self.po_header.organization.organization_name}<br>\n                        #{self.po_header.organization.organization_address_1}\n                        #{self.po_header.organization.organization_address_2}\n                    </h2> \n\n                    <h3>#{self.po_header.organization.organization_city} \n                        #{self.po_header.organization.organization_state} \n                         #{self.po_header.organization.organization_country}\n                        #{self.po_header.organization.organization_zipcode}\n                    </h3>\n                </div>\n            </div>\n\n            <div class=\"ms_text-2\">\n                <h1 class=\"ms_heading\">Ship To : </h1> \n                <div class=\"ms_text-6 ms-33\">\n                    <h2 class=\"ms_sub-heading\">Chess Group Inc </h2> <strong>#{@company_info.company_address1}</strong><strong>#{@company_info.company_address2}</strong></div>\n            </div>\n\n        </article>\n\n\n\n        <article>\n\n            <div class=\"ms_text-3-wrapper\">\n                <div class=\"ms_text-3\">\n                    <h2 class=\"ms_sub-heading\">QTY</h2> #{qty}</div>\n\n                <div class=\"ms_text-3\">\n                    <h2 class=\"ms_sub-heading\"> CUST P/N - ALL P/N</h2> #{c1}#{c2}</div>\n\n                <div class=\"ms_text-5\">\n                    <h2 class=\"ms_sub-heading\">DESCRIPTION</h2> #{b}</div>\n                <div class=\"ms_text-4\">\n                    <h2 class=\"ms_sub-heading\">  COST </h2>#{a}</div>\n                <div class=\"ms_text-4\">\n                    <h2 class=\"ms_sub-heading\">TOTAL </h2> \n                    <strong>#{self.po_header.po_total.to_f}</strong>\n                </div>\n            </div>\n        </article>\n\n\n        <article class=\"art-02\">\n\n            <div class=\"ms_text-55\">\n                <h1 class=\"ms_heading-3\">Comments:</h1> \n\n                <div class=\"ms_text-6\">                \n                    <strong class=\"ms-5\"></strong> \n               \n<!--                     <strong class=\"ms-5\">CONFIRM VIA E-MAIL 9/1/14!\nPLEASE SHIP UPS GROUND ASAP!\nTHANK YOU!</strong> \n -->\n                </div>\n            </div>\n\n            <div class=\"ms_text-2\">\n                <div class=\"ms_text-6\">\n                    <div class=\"ms_text-7 ms_text-8 \">\n                    </div>\n                    <div class=\"ms_text-7 ms_text-9 \"> <strong class=\"ms-1\">P.O. Total :</strong>  <strong class=\"ms-2\">#{self.po_header.po_total.to_f}</strong> \n                    </div>\n                </div>\n\n\n            </div>\n\n\n\n\n        </article>\n\n        <article>\n            <div class=\"footer\">\n\n                <div class=\"page\">\n                    <h3>Date</h3>\n                    <h4>#{self.po_header.created_at.strftime("%m/%d/%Y")}</h4>\n                </div>\n\n                <div class=\"page-center\">\n                    <h4>Audit Right Reserved - The Buyer, the Customer, the Government,the FAA and / or any other Page\nregulatory agencies reserve the right to audit Seller's books and records and the right to\ninspect at the Seller's plant any and all materials and systems.</h4>\n                </div>\n\n                <div class=\"original\">\n                    <h3>Page </h3>\n                    <h4>1\n</h4>\n                </div>\n\n\n        </article>\n\n\n        </div>\n\n</div>\n</body>\n</html>\n"

    if Rails.env == "production"
      html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    end
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

    p "==============================="
        p html

    p "=================================="

    puts "Successfully"
  end

end
