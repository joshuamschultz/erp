class ApplicationController < ActionController::Base
  	include CommonActions
  	protect_from_forgery

  	before_filter :authenticate_user!
  	before_filter :initialize_request
rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end


  before_filter :set_current_user

  def set_current_user
    User.current_user = current_user
  end
  	def after_sign_out_path_for(resource_or_scope)
  		CommonActions.clear_temp_objects
    	root_path
  	end
end
