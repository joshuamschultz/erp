ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
	:address =>'smtp.gmail.com',
    :port => 587,
    :user_name => 'eventsparks@gmail.com',
    :password => 'agileblaze525',
    :authentication => 'plain',
    :enable_starttls_auto => true  
}