class AccountController < ApplicationController
  
  def dashboard
  	
  end

  def tester
  	puts params.to_yaml
  	# render :layout => false
  end

end
