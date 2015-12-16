class HomeController < ApplicationController

  skip_before_filter :authenticate_user!

before_filter :cors_preflight_check
after_filter :cors_set_access_control_headers

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

  
	def index
	@organizations = Organization.all
	
	respond_to do |format|
		format.html # show.html.erb
		format.json { 
		
			render json: @organizations
		
		}
		end
	
require 'net/http'


	def index
		@so_header = SoHeader.last


url = URI.parse('http://192.254.141.167/~fstech/pic.php')
req = Net::HTTP::Get.new(url.to_s)
@res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}

 p "====================="
# puts res

 puts @res.body
 p "========================"
	
		render :layout => false



		
	end
end
