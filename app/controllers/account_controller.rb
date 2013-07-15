class AccountController < ApplicationController
  
  def dashboard
  	@menus[:dashboard][:active] = "active"  	
  end

  def tester
  	render :layout => false
  end

end
