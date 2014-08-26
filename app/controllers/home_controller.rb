class HomeController < ApplicationController
	def index
		@so_header = SoHeader.last
		render :layout => false
	end
end
