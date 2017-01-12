class Api::Vi::OrganizationsController < ApplicationController
  respond_to :json

    skip_before_action :authenticate_user!

    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers

    # For all responses in this controller, return the CORS access control headers.

    def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Max-Age'] = "1728000"
    end

    # If this is a preflight OPTIONS request, then short-circuit the
    # request, return only the necessary headers and return an empty
    # text/plain.

    def cors_preflight_check
        if request.method == :options
            headers['Access-Control-Allow-Origin'] = '*'
            headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
            headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
            headers['Access-Control-Max-Age'] = '1728000'
            render :text => '', :content_type => 'text/plain'
        end
    end
  respond_to :json

  def index
    p "==============================================================="
    @organizations = Organization.all
    p    @organizations

    p "========================================="
    respond_with @organizations
  end
end
