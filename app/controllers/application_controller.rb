class ApplicationController < ActionController::Base
  include CommonActions
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :initialize_request

	def after_sign_in_path_for(user)
		account_dashboard_path
	end

	def initialize_request
		params[:layout] = params[:layout] == "false" ? false : true

		@menus = application_main_menu
		@shortcuts = application_shortcuts
	end







	private

	def application_main_menu
		menus = {}
		menus[:dashboard] = {:class => "glyphicons dashboard", :path => account_dashboard_path, :name => "Dashboard", :type => "single"}

		menus[:contacts] = {:class => "hasSubmenu glyphicons adress_book", :path => "#", :name => "Contacts", :type => "multiple"}
		menus[:contacts][:sub_menu] = 	[
											{:path => "#", :name => "Vendor"}, 
											{:path => "#", :name => "Customer"},
											{:path => "#", :name => "Support"}
										]

		menus[:quotes] = {:class => "hasSubmenu glyphicons notes", :path => "#", :name => "Quotes"}
		menus[:quotes][:sub_menu] = 	[
											{:path => "#", :name => "Vendor"}, 
											{:path => "#", :name => "Customer"}
										]

		menus[:purchases] = {:class => "glyphicons cart_in", :path => "#", :name => "Purchases", :type => "single"}

		menus[:sales] = {:class => "glyphicons stats", :path => "#", :name => "Sales", :type => "single"}

		menus[:inventory] = {:class => "glyphicons cargo", :path => "#", :name => "Inventory", :type => "single"}

		menus[:accounts] = {:class => "hasSubmenu glyphicons book", :path => "#", :name => "Accounts", :type => "multiple"}
		menus[:accounts][:sub_menu] = 	[
											{:path => "#", :name => "Receivables"}, 
											{:path => "#", :name => "Payables"},
											{:path => "#", :name => "Payments"}
										]
		
		menus[:general_ledger] = {:class => "hasSubmenu glyphicons book_open", :path => "#", :name => "General Ledger", :type => "multiple"}
		menus[:general_ledger][:sub_menu] = 	[
											{:path => "#", :name => "Journal Entries"}, 
											{:path => "#", :name => "Chart of Accounts"}
										]		

		menus[:quality] = {:class => "hasSubmenu glyphicons log_book", :path => "#", :name => "Quality", :type => "multiple"}
		menus[:quality][:sub_menu] = 	[
											{:path => "#", :name => "Lots"}, 
											{:path => "#", :name => "Instruments"},
											{:path => "#", :name => "Quality Actions"},
											{:path => "#", :name => "Customer Qualities"}
										]
		
		menus[:shipments] = {:class => "glyphicons boat", :path => "#", :name => "Shipments", :type => "single"}

		menus[:reports] = {:class => "glyphicons charts", :path => "#", :name => "Reports", :type => "single"}

		menus[:documentation] = {:class => "hasSubmenu glyphicons briefcase", :path => "#", :name => "Documentation", :type => "multiple"}
		menus[:documentation][:sub_menu] = 	[
											{:path => "#", :name => "Internal"}, 
											{:path => "#", :name => "Vendor"},
											{:path => "#", :name => "Customer"},
											{:path => "#", :name => "General"}
										]

		menus[:system] = {:class => "hasSubmenu glyphicons cogwheels", :path => "#", :name => "System", :type => "multiple"}
		menus[:system][:sub_menu] = 	[
											{:path => "#", :name => "Home Info"},
											{:path => "#", :name => "Territories"},
											{:path => "#", :name => "Privileges"},
											{:path => "#", :name => "Documents"},
											{:path => owners_path, :name => "Owners"},
											{:path => materials_path, :name => "Materials"},
											{:path => process_types_path, :name => "Processes"},
											{:path => vendor_qualities_path, :name => "Vendor Qualities"},
											{:path => customer_qualities_path, :name => "Customer Qualities"}
										]
		menus
	end

	def application_shortcuts
		[	{:name => "System", :class => "glyphicons cogwheels", :drop_down => true, :path => "#", 
				:sub_menu => [	
								{:name => "Owners", :class => "", :drop_down => false, :path => owners_path, :sub_menu => []},
								{:name => "Materials", :class => "", :drop_down => false, :path => materials_path, :sub_menu => []},
								{:name => "Processes", :class => "", :drop_down => false, :path => process_types_path, :sub_menu => []},
								{:name => "Vendor Qualities", :class => "", :drop_down => false, :path => vendor_qualities_path, :sub_menu => []}
							]					
			}
		]

		
	end
  
end
