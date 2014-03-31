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

end
