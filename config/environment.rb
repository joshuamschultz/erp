# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AllianceFasteners::Application.initialize!

Mime::Type.register 'application/pdf', :pdf

Rails.logger = Logger.new(STDOUT)
Rails.logger = Log4r::Logger.new("Application Log")