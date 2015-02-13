class HomeController < ApplicationController
	
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
