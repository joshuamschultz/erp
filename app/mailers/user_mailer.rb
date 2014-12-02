class UserMailer < ActionMailer::Base
  default from: "Alliance Fastners <do-not-reply@alliance-fastners.com>"




  def purchase_order_mail(po_header,vendor_email)
    @po_header = po_header
    @vendor_email = vendor_email
    file_name = @po_header.po_identifier
    file_path = "#{Rails.root.to_s}/public/purchase_report/#{@po_header.po_identifier}.pdf"
    attachments[file_name.to_s + '.pdf'] = File.read(file_path)
    mail( to: "#{@po_header.organization.organization_email}", 
           cc: @vendor_email,
          subject: "Purchase Order [#{@po_header.po_identifier}]"
    )
  end 


  def customer_billing_mail(receivable,customer_email)
    @receivable = receivable
    @customer_email = customer_email
    file_name = @receivable.so_header.so_identifier
    file_path = "#{Rails.root.to_s}/public/invoice_report/#{@receivable.so_header.so_identifier}.pdf"
    attachments[file_name.to_s + '.pdf'] = File.read(file_path)
    mail( to: @customer_email, 
          subject: "Invoice [#{@receivable.receivable_identifier}]"
    )
  end 


  def welcome_email(user, params = {})
      @user = user
      to_address = (ENV['RAILS_ENV'] == "development") ? "mohan.ms1998@gmail.com" : ["sreejeshkp@agileblaze.com", "joshuamschultz@gmail.com"]

      # "sreejeshkp@agileblaze.com"

      # ["sreejeshkp@agileblaze.com", "joshuamschultz@gmail.com"]
        
        mail(:to => @user.email, :subject => "Welcome to Alliance Fastners").deliver
        puts "Mail Send!"
  end


  def send_quote(quote, quote_vendor)
    to_address = (ENV['RAILS_ENV'] == "development") ? "kannanstays@gmail.com" : ["sreejeshkp@agileblaze.com", "joshuamschultz@gmail.com"]
    # to_address = quote_vendor.oraganzition.organization_email
    @quote = quote
    @quote_vendor = quote_vendor
    if @quote.attachments
      @quote.attachments.each do |attachmen|
        file_path = "#{Rails.root.to_s}/public"+attachmen.attachment.url(:original)
        file_name = attachmen.attachment_file_name
        attachments[file_name] = File.read(file_path)
      end
    end
    mail(:to => to_address, :subject => "Quotes").deliver
    puts "Mail Send!"

  end


  def send_customer_quote(customer_quote_id, address)
    to_address = (ENV['RAILS_ENV'] == "development") ? "kannanstays@gmail.com" : ["sreejeshkp@agileblaze.com", "joshuamschultz@gmail.com"]
    @customer_quote = CustomerQuote.find(customer_quote_id)
    organization = @customer_quote.organization    
    if organization.contact_type.type_value == 'email'
       # to_address = address.present? ? organization.contacts.find(address).contact_email : organization.organization_email    
      if @customer_quote.attachments
        @customer_quote.attachments.each do |attachmen|
          file_path = "#{Rails.root.to_s}/public"+attachmen.attachment.url(:original)
          file_name = attachmen.attachment_file_name
          attachments[file_name] = File.read(file_path)
        end
      end      
      mail(:to => to_address, :subject => "Quotes").deliver
      puts "Mail Send!"
    else
      #  Module for fax
    end
    
  end

end
