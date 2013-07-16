class AccountController < ApplicationController
  
  def dashboard
  	@menus[:dashboard][:active] = "active"  	
  end

  def tester
  	b = [	{:name => "link 1", :class => "", :drop_down => true, 
	  				:sub_menu => [	{:name => "link 1.1", :class => "", :drop_down => true, 
  									:sub_menu => [	{:name => "link 1.1.1", :class => "", :drop_down => false, 
	  												:sub_menu => [] 
	  												}
	  											 ] 
									}
								 ] 
		  	}
		]

  	a =  CommonActions.process_application_shortcuts('', @shortcuts)
  	render :text => a and return
  end

end
