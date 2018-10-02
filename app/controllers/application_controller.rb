require 'application_responder'

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  self.responder = ApplicationResponder

  include CommonActions
  
  respond_to :html, :json, :xml, :xhr

  before_action :set_locale
  before_action :determine_website
  before_action :authenticate_user!
  before_action :initialize_request
  before_action :set_current_user
  around_action :set_time_zone

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.permissions_error_url, alert: exception.message
  end

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

  def after_sign_out_path_for(_resource_or_scope)
    CommonActions.clear_temp_objects
    root_path
  end

  def determine_website
    $sitename = request.host_with_port
    ActionMailer::Base.default_url_options = { host: request.host_with_port }
  end
end
