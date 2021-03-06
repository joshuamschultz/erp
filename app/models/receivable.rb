# == Schema Information
#
# Table name: receivables
#
#  id                     :integer          not null, primary key
#  organization_id        :integer
#  so_header_id           :integer
#  receivable_identifier  :string(255)
#  receivable_description :string(255)
#  receivable_cost        :decimal(25, 10)  default(0.0)
#  receivable_discount    :decimal(25, 10)  default(0.0)
#  receivable_total       :decimal(25, 10)  default(0.0)
#  receivable_notes       :text(65535)
#  receivable_status      :string(255)
#  receivable_active      :boolean
#  receivable_created_id  :integer
#  receivable_updated_id  :integer
#  created_at             :datetime
#  updated_at             :datetime
#  receivable_invoice     :string(255)
#  gl_account_id          :integer
#  receivable_freight     :decimal(25, 10)  default(0.0)
#  receivable_disperse    :string(255)
#

class Receivable < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  scope :status_based_receivables, lambda{|status| where(:receivable_status => status) }
  # belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
   belongs_to :organization
  belongs_to :so_header
  belongs_to :gl_account

  has_many :receivable_shipments, :dependent => :destroy
  has_many :receivable_lines, :dependent => :destroy
  has_many :receipt_lines, :dependent => :destroy
  has_many :receivable_so_shipments, :dependent => :destroy
  has_many :so_shipments, through: :receivable_so_shipments
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :receivable_accounts, :dependent => :destroy
  has_many :gl_entries, through: :receivable_accounts

  accepts_nested_attributes_for :receivable_shipments
  accepts_nested_attributes_for :receivable_accounts

  # validates_presence_of :receivable_invoice, :organization
  # validates_presence_of :receivable_identifier, :if => Proc.new { |o| o.so_header.nil? }
  # validates_uniqueness_of :receivable_identifier

  validate :validate_receivable_account_total, on: :update

  after_create :process_after_create
  before_create :process_before_create

  before_save :process_before_save
  after_save :process_after_save

  def validate_receivable_account_total
      gl_account_ids = self.receivable_accounts.collect(&:gl_account_id)
      if gl_account_ids.uniq != gl_account_ids
          errors.add(:receivable_invoice, "have duplicate account entries added!")
      end

      receivable_total = self.receivable_lines.sum(:receivable_line_cost)
      receivable_total += self.so_shipments.sum(:so_shipped_cost) if self.so_header
      # receivable_discount_val = (receivable_total / 100) * self.receivable_discount rescue 0
      receivable_total = receivable_total.to_f - self.receivable_freight.to_f

      total_amount = 0
      self.receivable_accounts.each{|b| total_amount += b.receivable_account_amount.to_f }

      errors.add(:receivable_invoice, "total (#{self.receivable_total}) < dispersed account total (#{total_amount})") if total_amount > receivable_total
  end


  def process_before_save
      self.organization = self.so_header.organization if self.so_header
      # self.receivable_total = self.update_receivable_total
  end

  def process_before_create
      self.receivable_identifier = CommonActions.get_new_identifier(Receivable, :receivable_identifier, "I")
      self.receivable_status = "open"
  end

  def process_after_create
      if self.so_header
          self.so_header.so_lines.each do |so_line|
            if so_line.receivable_shipments.sum(:receivable_shipment_count) < so_line.so_line_shipped #so_line.so_line_quantity
                receivable_shipment = self.receivable_shipments.build
                receivable_shipment.so_line = so_line
                receivable_shipment.receivable_shipment_count = so_line.so_line_shipped - so_line.receivable_shipments.sum(:receivable_shipment_count)
                receivable_shipment.save
            end
          end
      end
      self.process_receivable_total
  end

  def process_after_save
      self.process_receivable_total
      # self.update_gl_account
      if self.so_header.present?
        generate_pdf
      end
  end




  def process_receivable_total
      Receivable.skip_callback("save", :before, :process_before_save)
      Receivable.skip_callback("save", :after, :process_after_save)
      receivable_total = self.update_receivable_total
      self.update_attributes(:receivable_total => receivable_total)
      Receivable.set_callback("save", :before, :process_before_save)
      Receivable.set_callback("save", :after, :process_after_save)
  end

  def update_receivable_total
      receivable_total = self.receivable_lines.sum(:receivable_line_cost)
      receivable_total += self.so_shipments.sum(:so_shipped_cost) if self.so_header
      # receivable_discount_val = (receivable_total / 100) * self.receivable_discount rescue 0
      receivable_total.to_f + receivable_freight.to_f
  end

  def receivable_discount_val
    receivable_total = self.receivable_lines.sum(:receivable_line_cost)
    receivable_total += self.so_shipments.sum(:so_shipped_cost) if self.so_header
    (receivable_total / 100) * self.receivable_discount rescue 0
  end

  def receivable_current_balance
      receipt_lines_discount = 0
      self.receipt_lines.each do |receipt_line|
        receipt_lines_discount += ((receipt_line.receivable.receivable_total*receipt_line.receipt.receipt_discount)/100).round(2)
        p receipt_lines_discount.to_f
      end
      ((self.receivable_total - receipt_lines_discount) - self.receipt_lines.sum(:receipt_line_amount)).round(2)
  end

  def redirect_path
      receivable_path(self)
  end

  def check_receivable_account_total
       sales_income_gl_id = GlAccount.where(:gl_account_identifier => '41010-010' ).first.id
       sales_freight_gl_id = GlAccount.where(:gl_account_identifier =>'51020-020').first.id
       sum_of_receivable_account = self.receivable_accounts.where(gl_account_id: sales_income_gl_id).sum(:receivable_account_amount) - self.receivable_accounts.where(gl_account_id: sales_freight_gl_id).sum(:receivable_account_amount)
       ( sum_of_receivable_account == self.receivable_total) ? "" : "(<strong style='color: red'>Mismatch b/w Receivable and Account Total)</strong>)".html_safe
  end

  # def update_gl_account
  #   accountsReceivableAmt = 0
  #   self.receivable_accounts.each do |receivable_account|
  #      CommonActions.update_gl_accounts(receivable_account.gl_account.gl_account_title, 'decrement',receivable_account.receivable_account_amount, self.id )
  #      accountsReceivableAmt += receivable_account.receivable_account_amount
  #   end
  #   CommonActions.update_gl_accounts('RECEIVBALE EMPLOYEES', 'increment',accountsReceivableAmt, self.id )

  #   # receivable_amount =  self.receivable_lines.sum(:receivable_line_cost) + receivable_freight
  #   # receivable_amount +=  self.so_shipments.sum(:so_shipped_cost) if self.so_header
  #   # CommonActions.update_gl_accounts('FREIGHT ; UPS', 'decrement', receivable_freight)
  #   # CommonActions.update_gl_accounts('RECEIVBALE EMPLOYEES', 'increment',receivable_amount )
  # end

  def generate_pdf

    @company_info = CompanyInfo.first
    @so_header = self.so_header
    content= product1= product2= product_description =''
    in_contact_title = in_contact_address1 = in_contact_address2 = in_contact_state = in_contact_czip = ''
    ship_contact_title = ship_contact_address1 = ship_contact_address2 = ship_contact_state = ship_contact_czip = ''

    if self.so_header.present?
      so = CommonActions.address(self.so_header)
      in_contact_title = '<span>'+so['b_c_title'].to_s+'</span>'
      in_contact_address1 = so['b_c_address_1'].to_s+'&nbsp;'
      in_contact_address2 = so['b_c_address_2'].to_s+'&nbsp;'
      in_contact_state = so['b_c_state'].to_s+'&nbsp;'
      so['b_c_country']= so['b_c_country'].present? ? so['b_c_country'] : ''
      so['b_c_zipcode']= so['b_c_zipcode'].present? ? so['b_c_zipcode'] : ''
      in_contact_czip = so['b_c_country'].to_s+'&nbsp;'+so['b_c_zipcode']
      ship_contact_title = '<span>'+so['s_c_title'].to_s+'</span>'
      ship_contact_address1 = so['s_c_address_1'].to_s+'&nbsp;'
      ship_contact_address2 = so['s_c_address_2'].to_s+'&nbsp;'
      ship_contact_state = so['s_c_state'].to_s+'&nbsp;'
      so['s_c_country']= so['s_c_country'].present? ? so['s_c_country'] : ''
      so['s_c_zipcode']= so['s_c_zipcode'].present? ? so['s_c_zipcode'] : ''
      ship_contact_czip = so['s_c_country'].to_s+'&nbsp;'+so['s_c_zipcode']
    end

    i = 1
    j = 1
    flag = 1
    flag2 = 1
    sub_total = 0.0

    s_sub_total = 0.0
    len = self.so_shipments.includes(:so_line, :receivable_so_shipment).length
    if len > 0
      sub_total+= self.so_shipments.includes(:so_line, :receivable_so_shipment).sum("so_shipped_cost").to_f
      s_sub_total+= sub_total + self.receivable_freight.to_f

      self.so_shipments.includes(:so_line, :receivable_so_shipment).each_with_index do |so_shipment, index|
        if so_shipment.so_line.item_revision.present?
        product_description= '<td>'+so_shipment.so_line.item_revision.item_description+'</td>'
        end
        if so_shipment.so_line.item.item_part_no == so_shipment.so_line.item_alt_name.item_alt_identifier
        product1 = '<tr><th scope="row">'+so_shipment.so_line.item.item_part_no+ '</th></tr>'
        else
        product1 = 'tr><th scope="row">'+so_shipment.so_line.item.item_part_no+ '</th></tr>'
        product2 = '<tr><th scope="row">'+so_shipment.so_line.item_alt_name.item_alt_identifier+'</th></tr>'
        end


        if i== 1
          content += ' <section><article class="ff"><div class="ms_image"><div class="ms_image-wrapper"><img alt=Report_heading src=http://erp.chessgroupinc.com/'+@company_info.try(:logo).try(:joint).try(:url, :original).to_s+' /> </div><div class="ms_image-text"><h3> '+@company_info.company_address1+' <br> '+@company_info.company_address2+' </h3><h5><span> P:</span>  '+@company_info.company_phone1+' <br><span> F:&nbsp;</span> '+@company_info.company_fax
          content +=' </h5></div></div><div class="ms_image-2"><h2> Invoice</h2><div class="ms_image-5"><div class="ms_image-6"><h4> Date</h4><h5> '+self.created_at.strftime("%m/%d/%Y")+' </h5><div class="space"></div><h4> Chess S.O.#</h4> <h5> '+@so_header.so_identifier.to_s+' </h5> </div><div class="ms_image-6 ms_image-7"><h4> Inv No</h4><h5> '+self.receivable_identifier.to_s+' </h5><div class="space"></div><h4> Customer P.O.#</h4> <h5> '+@so_header.so_header_customer_po.to_s
          content +='  </h5>  </div><div class="clear"></div></div></div></article>'
          if flag ==1
             content += '<article class="art-01"><div class="ms_text-wra"><h2></h2><div class="ms_text"><h1 class="ms_heading">Bill To :</h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'+in_contact_title.to_s+''+in_contact_address1.to_s+''+in_contact_address2.to_s+''+in_contact_state.to_s+''+in_contact_czip.to_s+'</h2></div></div></div><div class="ms_text-wra-02"><h2></h2><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'
             content += ship_contact_title.to_s+''+ship_contact_address1.to_s+''+ship_contact_address2.to_s+''+ship_contact_state.to_s+''+ship_contact_czip.to_s+'</div></div></div></article>'
            flag =0;
          end

          if flag2 ==1
            content += '<article class="art-01 art-04 "><table width="640" border="0" cellpadding="0" cellspacing="0"><tr align="center" class="hea"><td width="72">ORDERED</td><td width="75">SHIPPED</td><td width="67">P/N</td><td width="224">DESCRIPTION</td><td width="95">PRICE/E</td><td width="107">TOTAL</td></tr>'
            flag2=0;
          else
              content += '<article class="art-01 hei "><table width="640" border="0" cellpadding="0" cellspacing="0"><tr align="center" class="hea"><td width="72">ORDERED</td><td width="75">SHIPPED</td><td width="67">P/N</td><td width="224">DESCRIPTION</td><td width="95">PRICE/E</td><td width="107">TOTAL</td></tr>'
          end
        end

        content += ' <tr class="h-pad" valign="top" align="left"><td>'+so_shipment.so_line.so_line_quantity.to_s+'</td><td> '+so_shipment.so_shipped_count.to_s+'</td><td><table width="100%" border="0">'+product1+''+product2+'</table></td>'+product_description+'<td> '+so_shipment.so_line.so_line_sell.to_s+'</td><td>'+so_shipment.so_shipped_cost.to_s+'</td></tr>'

        if i==10
          content += '</table></article>'
          content += '<article ><div class="footer"><div class="page"><h3>Page</h3><span>'+j.to_s+' </span></div><div class="original"><table width="250" border="0" cellpadding="0" cellspacing="0"><tr><th width="169" align="right" scope="row">SUB TOTAL :</th><td width="131" align="right">'+sub_total.to_s+'</td></tr><tr><th align="right" scope="row">FREIGHT :</th><td align="right">'+self.receivable_freight.to_s+'</td></tr><tr><th align="right" scope="row">TOTAL :</th><td align="right">'+s_sub_total.to_s+'  </td></tr></table></div></div></article> </section>'
          content += ' <div style="page-break-after: always; "> &nbsp;  </div>'
        end

        if len == index+1 && i != 10
          # j = 1
          # j+=1
          content += '</table></article>'
          content += '<article ><div class="footer"><div class="page"><h3>Page</h3><span>'+j.to_s+'</span></div><div class="original"><table width="250" border="0" cellpadding="0" cellspacing="0"><tr><th width="169" align="right" scope="row">SUB TOTAL :</th><td width="131" align="right">'+sub_total.to_s+'</td></tr><tr><th align="right" scope="row">FREIGHT :</th><td align="right">'+self.receivable_freight.to_s+'</td></tr><tr><th align="right" scope="row">TOTAL :</th><td align="right">'+s_sub_total.to_s+'  </td></tr></table></div></div></article> </section>'
          content += '<div style="page-break-after: always;"> &nbsp; </div>'
        end

        i +=1

        if i==11
          j+=1
          i= 1
          content
        end

      end
      content
    else
      content =  '<section>
      <article class="ff"><div class="ms_image"><div class="ms_image-wrapper"><img alt=Report_heading src=http://erp.chessgroupinc.com/'+@company_info.logo.joint.url(:original)+' /> </div><div class="ms_image-text"><h3> '+@company_info.company_address1+' <br> '+@company_info.company_address2+' </h3><h5><span> P:</span>  '+@company_info.company_phone1+' <br><span> F:&nbsp;</span> '+@company_info.company_fax+' </h5></div></div><div class="ms_image-2"><h2> Invoice</h2><div class="ms_image-5"><div class="ms_image-6"><h4> Date</h4><h5> '+self.created_at.strftime("%m/%d/%Y")+' </h5><div class="space"></div><h4> Chess S.O.#</h4> <h5>  </h5> </div><div class="ms_image-6 ms_image-7"><h4> Inv No</h4><h5> '+self.receivable_identifier+' </h5><div class="space"></div><h4> Customer P.O.#</h4> <h5>   </h5>  </div><div class="clear"></div></div></div></article>
      <article class="art-01"><div class="ms_text-wra"><h2></h2><div class="ms_text"><h1 class="ms_heading">Bill To :</h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'+in_contact_title.to_s+''+in_contact_address1.to_s+''+in_contact_address2.to_s+''+in_contact_state.to_s+''+in_contact_czip.to_s+'</h2></div></div></div><div class="ms_text-wra-02"><h2></h2><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'+ship_contact_title.to_s+''+ship_contact_address1.to_s+''+ship_contact_address2.to_s+''+ship_contact_state.to_s+''+ship_contact_czip.to_s+'</div></div></div></article>
      <article class="art-01 art-04 "><table cellspacing="0" cellpadding="0" border="0" width="640"><tbody><tr align="center" class="hea"><td width="72">ORDERED</td><td width="75">SHIPPED</td><td width="67">P/N</td><td width="224">DESCRIPTION</td><td width="95">PRICE/E</td><td width="107">TOTAL</td></tr> <tr valign="top" align="left" class="h-pad"><td></td><td></td><td><table border="0" width="100%"><tbody><tr><th scope="row"></th></tr></tbody></table></td><td></td><td></td><td></td></tr></tbody></table></article>
      <article ><div class="footer"><div class="page"><h3>Page</h3><span>1 </span></div><div class="original"><table width="250" border="0" cellpadding="0" cellspacing="0"><tr><th width="169" align="right" scope="row">SUB TOTAL :</th><td width="131" align="right">'+sub_total.to_s+'</td></tr><tr><th align="right" scope="row">FREIGHT :</th><td align="right">'+self.receivable_freight.to_s+'</td></tr><tr><th align="right" scope="row">TOTAL :</th><td align="right">'+s_sub_total.to_s+'  </td></tr></table></div></div></article> </section>
      </section><div style=\"page-break-after: always;\"> &nbsp; </div>'.html_safe
    end
    html = %'<!DOCTYPE html><html><head><title>Member Spotlight</title><style>@charset "utf-8";body{font-family:Arial,Helvetica,sans-serif;font-size:14px}*{margin:0;padding:0}.clear{clear:both}.ms_wrapper{height:auto; width:640px; margin: 0 0 0 40px;}.ms_wrapper section{height:auto;width:640px}.ms_wrapper .ms_heading{font-size:14px;margin:7px 0 0;padding:0 0 10px;text-decoration:underline}.ms_wrapper .ms_image{float:left;font-size:22px;height:93px;margin:21px 0 0;text-align:center;width:310px}.ms_wrapper .ms_heading-3{text-decoration:underline;font-size:14px;margin:0 0 4px;padding:0 0 10px;float:left}article.art-01{margin:0;padding:3px 0 0}.ms_image-6 h5{font-size:14px!important}.ms_image-6 h4{font-size:13px;margin:0;text-decoration:underline}.ms_text-wra{float:left}.ms_text-wra-02{float:right}.space{margin:5px 0}.ms_image-5{ height: 69px;border:1px solid maroon;border-radius:12px;padding:4px 34px}.ms_wrapper .ms_image-2{float:right;font-size:22px;height:119px;text-align:center;width:310px}.ms_wrapper article{float:left;width:100%;min-height:121px}.ms_text-6>h2{font-size:14px}.h-pad2{float:left;margin:29px 0 0!important}.h-pad>td{border-bottom:1px dashed #444;font-size:13px;margin:0;padding:10px 0;text-align:center}.h-pad2 strong{float:left;font-size:11px;font-weight:400;margin:0;width:100%}.art-08 td{border:1px solid #444;font-size:12px;padding:5px 0}.ms_wrapper .ms_text{ height: 104px !important;float:left;font-size:15px;min-height:104px;line-height:23px;width:300px;margin:0}.ms_wrapper .ms_offers{float:left;margin:12px 0 0;padding:10px 0 0;text-align:center}.ms_wrapper .ms_sub-heading{color:#000;font-size:11px;line-height:16px;margin:10px 0 0}.ms_sub-heading>span{float:left;font-size:13px;margin:0 0 5px;width:100%}.ms_text strong,.ms_text-2 strong{float:left;font-size:13px;font-weight:400;line-height:19px;width:100%}.ms_text1 strong{float:left;font-size:14px;line-height:19px;width:100%;margin:1px 0;text-align:center;font-weight:700}.ms_text-6.ms-33 .ms_sub-heading{font-size:17px}.ms_text-6.ms-33{text-align:center}.ms_image-2 h3{color:navy;font-size:21px;font-weight:400;margin:17px 0 0;text-decoration:underline}.ms_text-6>h3{float:left;margin:0;padding:18px 0 0;font-size:14px}.ms_text-6{float:left;margin:0;width:212px}.hea td{border:1px solid #444;font-size:14px;font-weight:700;padding:9px 0}.ms_image-2 h2{color:#111;font-size:20px;font-weight:700;margin:2px 0}.ms_image-6{float:left}.ms_image-7{float:right}.ms_image-2 h5{color:maroon;font-size:16px;font-weight:700;margin:0}.ms_text-3-wrapper{float:left}.ms_text-3-wrapper .ms_text-3{width:126px;float:left}.ms_text-3-wrapper .ms_text-5{width:204px;float:left;text-align:center}.ms_text-3-wrapper .ms_text-4{float:left;width:91px}article.art-02{margin:18px 0 0;padding:7px 0 0;border:1px solid #555;border-radius:15px}.ms_text-5>strong{font-weight:400}.ms_text-3-wrapper .ms_text-3 strong,.ms_text-3-wrapper .ms_text-4 strong{float:left;font-size:14px;font-weight:400;line-height:19px;width:100%;margin:6px 0;text-align:center}.ms_text-3-wrapper .ms_sub-heading{border-bottom:1px solid #555;font-size:13px;margin:21px 0 12px;padding:0 0 12px;text-align:center}.ms_sub{font-size:15px;text-align:center;text-decoration:underline;margin:2px 0 10px}.ms_text{border-bottom:1px solid #555;border-top:1px solid #555;float:left;padding:0 0 10px;width:310px}.ms_text-wra h2,.ms_text-wra-02 h2{font-size:16px}.ms_text-2{border-bottom:1px solid #555;border-top:1px solid #555;float:right;min-height:104px;height: 104px !important;padding:0 0 10px;width:300px}.ms_text-7>strong{float:none}.ms_text-7.ms_text-8{border-bottom:1px solid #555;padding:0 0 9px}.ms-1{float:left!important;text-align:right;width:95px!important}.ms_text-7.ms_text-9 strong{font-size:14px;font-weight:700}.ms_text-7{float:left;margin:4px 0;width:90%}.ms_text1{float:left;margin:12px 28px 0;width:42%}.ms-5{color:maroon}.ms-2{margin:0 0 0 38px}.ms_text-55{float:left;padding:0 3px 11px;width:310px}.ms_wrapper .ms_image2{margin:0 20px 0 0;border:1px solid #ccc;padding:20px 0;text-align:center;font-size:22px}.ms_image2 h2{font-size:17px;margin:0}.ms_image2 strong{color:maroon;float:left;font-size:22px;margin:0 0 8px;width:100%}.original td{font-size:14px;font-weight:700;color:maroon}.ms_image2 p{font-size:18px;margin:0;color:navy}.footer{float:left;margin:10px 0 0;width:640px}.page{float:left;margin:0 0 0 20px}.page h3{float:left;font-size:14px;font-weight:700;margin:0 21px 0 0}.page h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.original th{color:maroon}.original{border:2px solid maroon;border-radius:12px;float:right;padding:10px}.original h3{font-size:14px;font-weight:700;margin:12px 0 0}.original h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.ms_image-wrapper{float:left;height:69px;margin:20px 0 0 3px;width:150px}.ms_image-wrapper img{width:128px}.ms_image-text span{font-weight:700}.ms_image-text{float:right;margin:6px 10px 0 0;width:120px}.ms_image-text h2{font-size:13px;margin:19px 0 8px;text-decoration:underline}.ms_image-text h3{border-bottom:1px solid #555;font-size:9px;font-weight:400;margin:12px 0 6px;padding:0 0 7px}.ms_image-text h5{border-bottom:1px solid #555;font-size:9px;font-weight:400;margin:0;padding:0 0 7px}.page-center{float:left;margin:8px 36px;width:394px}.page-center h3{font-size:14px;font-weight:700;margin:12px 0 0}.page-center h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.h-pad th{font-weight:400}.foot{background-color:#fff}.top-003{position:fixed;top:0;background-color:#fff}.art-01.to-003{padding:130px 0 0}.art-01.art-04{height:444px;padding:0 0 20px}.art-01.hei{height:575px}</style></head><body><div class="ms_wrapper" >#{content}</div><div style="page-break-after: always;"> </div> </body></html>'


    # if Rails.env == "production"
    #   # html = "http://erp.chessgroupinc.com/po_headers/#{self.po_header.id}/purchase_report"
    # end
    kit = PDFKit.new(html, :page_size => 'A4' )
    # Get an inline PDF
    pdf = kit.to_pdf
    p pdf
    # Save the PDF to a file
    path = Rails.root.to_s+"/public/invoice_report"
    if File.directory? path
    path = path+"/"+self.so_header.so_identifier.to_s+".pdf"
    kit.to_file(path)
    else
    Dir.mkdir path
    path = path+"/"+self.so_header.so_identifier.to_s+".pdf"
    kit.to_file(path)
    end


  end

  # def self.open_receivables(item_revision,status)
  #   receivables = []
  #   @item = ItemRevision.find(item_revision)
  #   @item.so_lines.each do |so_line|
  #     unless so_line.so_header.receivables.empty?
  #       receivables= so_line.so_header.receivables.status_based_receivables(status || "open")
  #     end
  #   end
  #   return receivables
  # end
  def self.open_revision_receivables(item_revision,status)
    receivables = []
    @item_revision = ItemRevision.find(item_revision)
    @item_revision.so_lines.each do |so_line|
      unless so_line.so_header.receivables.empty?
        receivables << so_line.so_header.receivables.order('created_at desc')
      end
    end
    return receivables.flatten.compact.uniq
  end

  def invoice_code
    @company_info = CompanyInfo.first
    @so_header = self.so_header
    content= product1= product2= product_description =''
    in_contact_title = in_contact_address1 = in_contact_address2 = in_contact_state = in_contact_czip = ''
    ship_contact_title = ship_contact_address1 = ship_contact_address2 = ship_contact_state = ship_contact_czip = ''

    if self.so_header.present?
      so = CommonActions.address(self.so_header)
      in_contact_title = '<span>'+so['b_c_title'].to_s+'</span>'
      in_contact_address1 = so['b_c_address_1'].to_s+'&nbsp;'
      in_contact_address2 = so['b_c_address_2'].to_s+'&nbsp;'
      in_contact_state = so['b_c_state'].to_s+'&nbsp;'
      in_contact_czip = so['b_c_country'].to_s+'&nbsp;'+so['b_c_zipcode'].to_s
      ship_contact_title = '<span>'+so['s_c_title'].to_s+'</span>'
      ship_contact_address1 = so['s_c_address_1'].to_s+'&nbsp;'
      ship_contact_address2 = so['s_c_address_2'].to_s+'&nbsp;'
      ship_contact_state = so['s_c_state'].to_s+'&nbsp;'
      ship_contact_czip = so['s_c_country'].to_s+'&nbsp;'+so['s_c_zipcode'].to_s
    end

    i = 1
    j = 1
    flag = 1
    flag2 = 1
    sub_total = 0.0

    s_sub_total = 0.0
    len = self.so_shipments.includes(:so_line, :receivable_so_shipment).length
    if len > 0

      sub_total+= self.so_shipments.includes(:so_line, :receivable_so_shipment).sum("so_shipped_cost").to_f
      s_sub_total+= sub_total + self.receivable_freight.to_f

      self.so_shipments.includes(:so_line, :receivable_so_shipment).each_with_index do |so_shipment, index|
        if so_shipment.so_line.item_revision.present?
        product_description= '<td>'+so_shipment.so_line.item_revision.item_description+'</td>'
        end
        if so_shipment.so_line.item.item_part_no == so_shipment.so_line.item_alt_name.item_alt_identifier
        product1 = '<tr><th scope="row">'+so_shipment.so_line.item.item_part_no+ '</th></tr>'
        else
        product1 = 'tr><th scope="row">'+so_shipment.so_line.item.item_part_no+ '</th></tr>'
        product2 = '<tr><th scope="row">'+so_shipment.so_line.item_alt_name.item_alt_identifier+'</th></tr>'
        end


        if i== 1
          content += ' <section><article class="ff"><div class="ms_image"><div class="ms_image-wrapper"><img alt=Report_heading src=http://erp.chessgroupinc.com/'+@company_info.try(:logo).try(:joint).try(:url,:original).to_s+' /> </div><div class="ms_image-text"><h3> '+@company_info.company_address1+' <br> '+@company_info.company_address2+' </h3><h5><span> P:</span>  '+@company_info.company_phone1+' <br><span> F:&nbsp;</span> '+@company_info.company_fax
          content +=' </h5></div></div><div class="ms_image-2"><h2> Invoice</h2><div class="ms_image-5"><div class="ms_image-6"><h4> Date</h4><h5> '+self.created_at.strftime("%m/%d/%Y")+' </h5><div class="space"></div><h4> Chess S.O.#</h4> <h5> '+@so_header.so_identifier+' </h5> </div><div class="ms_image-6 ms_image-7"><h4> Inv No</h4><h5> '+self.receivable_identifier+' </h5><div class="space"></div><h4> Customer P.O.#</h4> <h5> '
          content +=@so_header.so_header_customer_po+'  </h5>  </div><div class="clear"></div></div></div></article>'
          if flag ==1
             content += '<article class="art-01"><div class="ms_text-wra"><h2></h2><div class="ms_text"><h1 class="ms_heading">Bill To :</h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'+in_contact_title.to_s+''+in_contact_address1.to_s+''+in_contact_address2.to_s+''+in_contact_state.to_s+''+in_contact_czip.to_s+'</h2></div></div></div><div class="ms_text-wra-02"><h2></h2><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'
             content +=ship_contact_title.to_s+''+ship_contact_address1.to_s+''+ship_contact_address2.to_s+''+ship_contact_state.to_s+''+ship_contact_czip.to_s+'</div></div></div></article>'
            flag =0;
          end

          if flag2 ==1
            content += '<article class="art-01 art-04 "><table width="640" border="0" cellpadding="0" cellspacing="0"><tr align="center" class="hea"><td width="72">ORDERED</td><td width="75">SHIPPED</td><td width="67">P/N</td><td width="224">DESCRIPTION</td><td width="95">PRICE/E</td><td width="107">TOTAL</td></tr>'
            flag2=0;
          else
              content += '<article class="art-01 hei "><table width="640" border="0" cellpadding="0" cellspacing="0"><tr align="center" class="hea"><td width="72">ORDERED</td><td width="75">SHIPPED</td><td width="67">P/N</td><td width="224">DESCRIPTION</td><td width="95">PRICE/E</td><td width="107">TOTAL</td></tr>'
          end
        end

        content += ' <tr class="h-pad" valign="top" align="left"><td>'+so_shipment.so_line.so_line_quantity.to_s+'</td><td> '+so_shipment.so_shipped_count.to_s+'</td><td><table width="100%" border="0">'+product1+''+product2+'</table></td>'+product_description+'<td> '+so_shipment.so_line.so_line_sell.to_s+'</td><td>'+so_shipment.so_shipped_cost.to_s+'</td></tr>'

        if i==10
          content += '</table></article>'
          content += '<article ><div class="footer"><div class="page"><h3>Page</h3><span> '+j.to_s+' </span></div><div class="original"><table width="250" border="0" cellpadding="0" cellspacing="0"><tr><th width="169" align="right" scope="row">SUB TOTAL :</th><td width="131" align="right">'+sub_total.to_s+'</td></tr><tr><th align="right" scope="row">FREIGHT :</th><td align="right">'+self.receivable_freight.to_s+'</td></tr><tr><th align="right" scope="row">TOTAL :</th><td align="right">'
          content += s_sub_total.to_s+'  </td></tr></table></div></div></article> </section>'
          content += ' <div style="page-break-after:always;">&nbsp; </div>'

        end

        if len == index+1 && i != 10
          # j = 1
          # j+=1
          content += '</table></article>'
          content += '<article ><div class="footer"><div class="page"><h3>Page</h3><span> '+j.to_s+'</span></div><div class="original"><table width="250" border="0" cellpadding="0" cellspacing="0"><tr><th width="169" align="right" scope="row">SUB TOTAL :</th><td width="131" align="right">'+sub_total.to_s+'</td></tr><tr><th align="right" scope="row">FREIGHT :</th><td align="right">'+self.receivable_freight.to_s+'</td></tr><tr><th align="right" scope="row">TOTAL :</th><td align="right">'
          content += s_sub_total.to_s+'  </td></tr></table></div></div></article> </section>'
          content += ' <div style="page-break-after:always;">&nbsp; </div>'

        end

        i +=1

        if i==11
          j+=1
          i= 1
          content
        end

      end
      content
    else
      content =  '

      <section>
        <article class="ff"><div class="ms_image"><div class="ms_image-wrapper"><img alt=Report_heading src=http://erp.chessgroupinc.com/'+@company_info.logo.joint.url(:original)+' /> </div><div class="ms_image-text"><h3> '+@company_info.company_address1+' <br> '+@company_info.company_address2+' </h3><h5><span> P:</span>  '+@company_info.company_phone1+' <br><span> F:&nbsp;</span> '+@company_info.company_fax+' </h5></div></div><div class="ms_image-2"><h2> Invoice</h2><div class="ms_image-5"><div class="ms_image-6"><h4> Date</h4><h5> '+self.created_at.strftime("%m/%d/%Y")+' </h5><div class="space"></div><h4> Chess S.O.#</h4> <h5>  </h5> </div><div class="ms_image-6 ms_image-7"><h4> Inv No</h4><h5> '+self.receivable_identifier+' </h5><div class="space"></div><h4> Customer P.O.#</h4> <h5>   </h5>  </div><div class="clear"></div></div></div></article>
        <article class="art-01"><div class="ms_text-wra"><h2></h2><div class="ms_text"><h1 class="ms_heading">Bill To :</h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'+in_contact_title.to_s+''+in_contact_address1.to_s+''+in_contact_address2.to_s+''+in_contact_state.to_s+''+in_contact_czip.to_s+'</h2></div></div></div><div class="ms_text-wra-02"><h2></h2><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1> <div class="ms_text-6"><h2 class="ms_sub-heading">'+ship_contact_title.to_s+''+ship_contact_address1.to_s+''+ship_contact_address2.to_s+''+ship_contact_state.to_s+''+ship_contact_czip.to_s+'</div></div></div></article>
        <article class="art-01 art-04 "><table cellspacing="0" cellpadding="0" border="0" width="640"><tbody><tr align="center" class="hea"><td width="72">ORDERED</td><td width="75">SHIPPED</td><td width="67">P/N</td><td width="224">DESCRIPTION</td><td width="95">PRICE/E</td><td width="107">TOTAL</td></tr> <tr valign="top" align="left" class="h-pad"><td></td><td></td><td><table border="0" width="100%"><tbody><tr><th scope="row"></th></tr></tbody></table></td><td></td><td></td><td></td></tr></tbody></table></article>
        <article ><div class="footer"><div class="page"><h3>Page</h3><span>1 </span></div><div class="original"><table width="250" border="0" cellpadding="0" cellspacing="0"><tr><th width="169" align="right" scope="row">SUB TOTAL :</th><td width="131" align="right">'+sub_total.to_s+'</td></tr><tr><th align="right" scope="row">FREIGHT :</th><td align="right">'+self.receivable_freight.to_s+'</td></tr><tr><th align="right" scope="row">TOTAL :</th><td align="right">'+s_sub_total.to_s+'  </td></tr></table></div></div></article> </section>
        </section><div style="page-break-after:always;">&nbsp; </div>'




    end







    # html = %'<div class="ms_wrapper" >#{content}</div>'

    html = %'<!DOCTYPE html><html><head><title>Member Spotlight</title><style>@charset "utf-8";body{font-family:Arial,Helvetica,sans-serif;font-size:14px}*{margin:0;padding:0}.clear{clear:both}.ms_wrapper{height:auto; width:640px;}.ms_wrapper section{height:auto;width:640px}.ms_wrapper .ms_heading{font-size:14px;margin:7px 0 0;padding:0 0 10px;text-decoration:underline}.ms_wrapper'
    html += '.ms_image{float:left;font-size:22px;height:93px;margin:21px 0 0;text-align:center;width:310px}.ms_wrapper .ms_heading-3{text-decoration:underline;font-size:14px;margin:0 0 4px;padding:0 0 10px;float:left}article.art-01{margin:0;padding:3px 0 0}.ms_image-6 h5{font-size:14px!important}.ms_image-6 h4{font-size:13px;margin:0;text-decoration:underline}.ms_text-wra{float:left}'
    html += '.ms_text-wra-02{float:right}.space{margin:5px 0}.ms_image-5{ height: 69px;border:1px solid maroon;border-radius:12px;padding:4px 34px}.ms_wrapper .ms_image-2{float:right;font-size:22px;height:119px;text-align:center;width:310px}.ms_wrapper article{float:left;width:100%;min-height:121px}.ms_text-6>h2{font-size:14px}.h-pad2{float:left;margin:29px 0 0!important}'
    html += '.h-pad>td{border-bottom:1px dashed #444;font-size:13px;margin:0;padding:10px 0;text-align:center}.h-pad2 strong{float:left;font-size:11px;font-weight:400;margin:0;width:100%}.art-08 td{border:1px solid #444;font-size:12px;padding:5px 0}.ms_wrapper .ms_text{ height: 104px !important;float:left;font-size:15px;min-height:104px;line-height:23px;width:300px;margin:0}'
    html += '.ms_wrapper .ms_offers{float:left;margin:12px 0 0;padding:10px 0 0;text-align:center}.ms_wrapper .ms_sub-heading{color:#000;font-size:11px;line-height:16px;margin:10px 0 0}.ms_sub-heading>span{float:left;font-size:13px;margin:0 0 5px;width:100%}.ms_text strong,.ms_text-2 strong{float:left;font-size:13px;font-weight:400;line-height:19px;width:100%}.ms_text1 strong{float:left;font-size:14px;line-height:19px;width:100%;margin:1px 0;text-align:center;font-weight:700}'
    html += '.ms_text-6.ms-33 .ms_sub-heading{font-size:17px}.ms_text-6.ms-33{text-align:center}.ms_image-2 h3{color:navy;font-size:21px;font-weight:400;margin:17px 0 0;text-decoration:underline}.ms_text-6>h3{float:left;margin:0;padding:18px 0 0;font-size:14px}.ms_text-6{float:left;margin:0;width:212px}.hea td{border:1px solid #444;font-size:14px;font-weight:700;padding:9px 0}.ms_image-2 h2{color:#111;font-size:20px;font-weight:700;margin:2px 0}.ms_image-6{float:left}'
    html += '.ms_image-7{float:right}.ms_image-2 h5{color:maroon;font-size:16px;font-weight:700;margin:0}.ms_text-3-wrapper{float:left}.ms_text-3-wrapper .ms_text-3{width:126px;float:left}.ms_text-3-wrapper .ms_text-5{width:204px;float:left;text-align:center}.ms_text-3-wrapper .ms_text-4{float:left;width:91px}article.art-02{margin:18px 0 0;padding:7px 0 0;border:1px solid #555;border-radius:15px}.ms_text-5>strong{font-weight:400}.ms_text-3-wrapper .ms_text-3 strong,'
    html += '.ms_text-3-wrapper .ms_text-4 strong{float:left;font-size:14px;font-weight:400;line-height:19px;width:100%;margin:6px 0;text-align:center}.ms_text-3-wrapper .ms_sub-heading{border-bottom:1px solid #555;font-size:13px;margin:21px 0 12px;padding:0 0 12px;text-align:center}.ms_sub{font-size:15px;text-align:center;text-decoration:underline;margin:2px 0 10px}.ms_text{border-bottom:1px solid #555;border-top:1px solid #555;float:left;padding:0 0 10px;width:310px}'
    html += '.ms_text-wra h2,.ms_text-wra-02 h2{font-size:16px}.ms_text-2{border-bottom:1px solid #555;border-top:1px solid #555;float:right;min-height:104px;height: 104px !important;padding:0 0 10px;width:300px}.ms_text-7>strong{float:none}.ms_text-7.ms_text-8{border-bottom:1px solid #555;padding:0 0 9px}.ms-1{float:left!important;text-align:right;width:95px!important}.ms_text-7.ms_text-9 strong{font-size:14px;font-weight:700}.ms_text-7{float:left;margin:4px 0;width:90%}'
    html += '.ms_text1{float:left;margin:12px 28px 0;width:42%}.ms-5{color:maroon}.ms-2{margin:0 0 0 38px}.ms_text-55{float:left;padding:0 3px 11px;width:310px}.ms_wrapper .ms_image2{margin:0 20px 0 0;border:1px solid #ccc;padding:20px 0;text-align:center;font-size:22px}.ms_image2 h2{font-size:17px;margin:0}.ms_image2 strong{color:maroon;float:left;font-size:22px;margin:0 0 8px;width:100%}.original td{font-size:14px;font-weight:700;color:maroon}.ms_image2 p{font-size:18px;margin:0;color:navy}'
    html += '.footer{float:left;margin:10px 0 0;width:640px}.page{float:left;margin:0 0 0 20px}.page h3{float:left;font-size:14px;font-weight:700;margin:0 21px 0 0}.page h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.original th{color:maroon}.original{border:2px solid maroon;border-radius:12px;float:right;padding:10px}.original h3{font-size:14px;font-weight:700;margin:12px 0 0}.original h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}'
    html += '.ms_image-wrapper{float:left;height:69px;margin:20px 0 0 3px;width:150px}.ms_image-wrapper img{width:128px}.ms_image-text span{font-weight:700}.ms_image-text{float:right;margin:6px 10px 0 0;width:120px}.ms_image-text h2{font-size:13px;margin:19px 0 8px;text-decoration:underline}.ms_image-text h3{border-bottom:1px solid #555;font-size:9px;font-weight:400;margin:12px 0 6px;padding:0 0 7px}'
    html += '.ms_image-text h5{border-bottom:1px solid #555;font-size:9px;font-weight:400;margin:0;padding:0 0 7px}'
    html += '.page-center{float:left;margin:8px 36px;width:394px}.page-center h3{font-size:14px;font-weight:700;margin:12px 0 0}.page-center h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.h-pad th{font-weight:400}.foot{background-color:#fff}.top-003{position:fixed;top:0;background-color:#fff}.art-01.to-003{padding:130px 0 0}.art-01.art-04{height:444px;padding:0 0 20px}'
    html += ".art-01.hei{height:575px}</style></head><body><div class='ms_wrapper' >#{content}</div><div style='page-break-after: always;''> </div> </body></html>"
    html.html_safe
  end
end
