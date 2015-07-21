class ApplicationController < ActionController::Base
  	include CommonActions
  	protect_from_forgery

  	before_filter :authenticate_user!
  	before_filter :initialize_request
    
    rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.permissions_error_url, :alert => exception.message
  end


  before_filter :set_current_user
  around_filter :set_time_zone
  
  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def set_current_user
    User.current_user = current_user
  end
  	def after_sign_out_path_for(resource_or_scope)
  		CommonActions.clear_temp_objects
    	root_path
  	end
end
