class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :initialize_request

	def after_sign_in_path_for(user)
		account_dashboard_path
	end

	def initialize_request
		params[:layout] = params[:layout] == "false" ? false : true
	end
  
end
