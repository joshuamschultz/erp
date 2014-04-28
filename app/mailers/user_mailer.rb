class UserMailer < ActionMailer::Base
  default from: "Alliance Fastners <do-not-reply@alliance-fastners.com>"

  def welcome_email(user, params = {})
      @user = user
      to_address = (ENV['RAILS_ENV'] == "development") ? "sreejeshkp@agileblaze.com" : ["sreejeshkp@agileblaze.com", "joshuamschultz@gmail.com"]

      # "sreejeshkp@agileblaze.com"

      # ["sreejeshkp@agileblaze.com", "joshuamschultz@gmail.com"]
        
        mail(:to => to_address, :subject => "Welcome to Alliance Fastners").deliver
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

    # to_address = quote_vendor.oraganzition.organization_email
    
    if organization.contact_type.type_value == 'email'
       to_address = address.present? ? organization.contacts.find(address).contact_email : organization.organization_email    
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
