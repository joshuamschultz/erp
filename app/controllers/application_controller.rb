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

		@menus = {}

		@menus[:dashboard] = {:icon => "dashboard", :path => "#", :name => "Dashboard", :type => "single"}

		@menus[:contacts] = {:icon => "book", :path => "#", :name => "Contacts", :type => "multiple"}
		@menus[:contacts][:sub_menu] = 	[
											{:path => "#", :name => "Vendor"}, 
											{:path => "#", :name => "Customer"},
											{:path => "#", :name => "Support"}
										]

		@menus[:quotes] = {:icon => "check", :path => "#", :name => "Quotes"}
		@menus[:quotes][:sub_menu] = 	[
											{:path => "#", :name => "Vendor"}, 
											{:path => "#", :name => "Customer"}
										]

		@menus[:purchases] = {:icon => "shopping-cart", :path => "#", :name => "Purchases", :type => "single"}

		@menus[:sales] = {:icon => "edit", :path => "#", :name => "Sales", :type => "single"}

		@menus[:inventory] = {:icon => "hdd", :path => "#", :name => "Inventory", :type => "single"}

		@menus[:accounts] = {:icon => "money", :path => "#", :name => "Accounts", :type => "multiple"}
		@menus[:accounts][:sub_menu] = 	[
											{:path => "#", :name => "Receivables"}, 
											{:path => "#", :name => "Payables"},
											{:path => "#", :name => "Payments"}
										]
		
		@menus[:general_ledger] = {:icon => "credit-card", :path => "#", :name => "General Ledger", :type => "multiple"}
		@menus[:general_ledger][:sub_menu] = 	[
											{:path => "#", :name => "Journal Entries"}, 
											{:path => "#", :name => "Chart of Accounts"}
										]		

		@menus[:quality] = {:icon => "beaker", :path => "#", :name => "Quality", :type => "multiple"}
		@menus[:quality][:sub_menu] = 	[
											{:path => "#", :name => "Lots"}, 
											{:path => "#", :name => "Instruments"},
											{:path => "#", :name => "Quality Actions"},
											{:path => "#", :name => "Customer Qualities"}
										]
		
		@menus[:shipments] = {:icon => "inbox", :path => "#", :name => "Shipments", :type => "single"}

		@menus[:reports] = {:icon => "bar-chart", :path => "#", :name => "Reports", :type => "single"}

		@menus[:documentation] = {:icon => "briefcase", :path => "#", :name => "Documentation", :type => "multiple"}
		@menus[:documentation][:sub_menu] = 	[
											{:path => "#", :name => "Internal"}, 
											{:path => "#", :name => "Vendor"},
											{:path => "#", :name => "Customer"},
											{:path => "#", :name => "General"}
										]

		@menus[:system] = {:icon => "cogs", :path => "#", :name => "System", :type => "multiple"}
		@menus[:system][:sub_menu] = 	[
											{:path => "#", :name => "Home Info"}, 
											{:path => "#", :name => "Owners"},
											{:path => "#", :name => "Territories"},
											{:path => "#", :name => "Privileges"},
											{:path => "#", :name => "Documents"},
											{:path => materials_path, :name => "Materials"}
										]
		
		@menus[:dashboard][:active] = "active"
	end
  
end
