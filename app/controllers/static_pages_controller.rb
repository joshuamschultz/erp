class StaticPagesController < ActionController::Base
  include CommonActions
  
  before_filter :initialize_request

  layout "application"

  def landing
  end

  def empty
  end

  def error_404
  end

  def error_500
  end

end
