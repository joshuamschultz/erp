# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AllianceFasteners::Application.initialize!

Mime::Type.register 'application/pdf', :pdf

config.logger = Logger.new(STDOUT)
config.logger = Log4r::Logger.new("Application Log")