class HomeController < ApplicationController

  skip_before_filter :authenticate_user!
	def index
	@organizations = Organization.all
	
	respond_to do |format|
		format.html # show.html.erb
		format.json { 
		
			render json: @organizations
		
		}
		end
	end
end
