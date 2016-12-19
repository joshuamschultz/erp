class ApplicationController < ActionController::Base
  include CommonActions
  protect_from_forgery

  before_action :set_locale
  before_action :authenticate_user!
  before_action :initialize_request

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.permissions_error_url, :alert => exception.message
  end


  before_action :set_current_user
  around_action :set_time_zone

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  def set_time_zone(&block)
    if current_user.present?
      Time.use_zone(current_user.time_zone, &block)
    else
      Time.use_zone('Eastern Time (US & Canada)', &block)
    end
  end

  def set_current_user
    User.current_user = current_user
  end

  def after_sign_out_path_for(resource_or_scope)
    CommonActions.clear_temp_objects
    root_path
  end
end
