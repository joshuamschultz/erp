class ApplicationController < ActionController::Base
  	include CommonActions
  	protect_from_forgery

  	before_filter :authenticate_user!
  	before_filter :initialize_request

  	def after_sign_out_path_for(resource_or_scope)
  		CommonActions.clear_temp_objects
    	root_path
  	end
end
