class ApplicationController < ActionController::Base
  	include CommonActions
  	protect_from_forgery

  	before_filter :authenticate_user!
  	before_filter :initialize_request  
end
