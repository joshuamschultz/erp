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

end
