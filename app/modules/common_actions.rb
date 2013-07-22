module CommonActions
	include Rails.application.routes.url_helpers

	def self.object_crud_paths(show_path, edit_path, delete_path, others = [])
		paths = ""
		paths += "<a href='#{show_path}' class='btn btn-mini btn-success'>View</a> " if show_path
      	paths += "<a href='#{edit_path}' class='btn btn-mini btn-info'>Edit</a> " if edit_path
      	paths += "<a href='#{delete_path}' class='btn btn-mini btn-danger' rel='nofollow' data-method='delete' data-confirm='Are you sure?'>Delete</a> " if delete_path
		others.each do |other|
			paths += "<a href='#{other[:path]}' class='btn btn-mini btn-orange'>#{other[:name]}</a> "
		end
		paths
	end
	

	def self.process_application_shortcuts(shortcuts_html, shortcuts)
		shortcuts.each do |shortcut|
			unless shortcut[:drop_down]
				shortcuts_html += '<li><a class="'+ shortcut[:class] + '" href="' + shortcut[:path] + '"><i></i>' + shortcut[:name] + '</a>'
			else
				shortcuts_html += '<li class="dropdown submenu">'
				shortcuts_html += '<a href="' + shortcut[:path] + '" class="dropdown-toggle ' + shortcut[:class] + '" data-toggle="dropdown"><i></i>' + shortcut[:name] + '</a>'
				shortcuts_html += '<ul class="dropdown-menu submenu-show submenu-hide pull-left">'
				shortcuts_html += CommonActions.process_application_shortcuts('', shortcut[:sub_menu])
				shortcuts_html += '</ul>'
			end
		end
		shortcuts_html += '</li>' if shortcuts.count > 0
		shortcuts_html
	end


  private


	def after_sign_in_path_for(user)
		account_dashboard_path
	end

	def initialize_request
		params[:layout] = params[:layout] == "false" ? false : true

		@home = {:name => CompanyInfo.first ? CompanyInfo.first.company_name : "Alliance Fasteners"}
		@menus = application_main_menu
		@shortcuts = application_shortcuts
	end


 	def render_error(status, exception)
  		case status
  			when 500
  				render static_pages_error_500_path , :layout => false, :status => :not_found

  			when 404
  				render static_pages_error_404_path , :layout => false, :status => :not_found

  			else
  		end    	
  	end


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
											{:path => company_infos_path, :name => "Company Info"},
											{:path => "#", :name => "Territories"},
											{:path => "#", :name => "Privileges"},
											{:path => "#", :name => "Documents"},
											{:path => owners_path, :name => "Owners"},
											{:path => materials_path, :name => "Materials"},
											{:path => process_types_path, :name => "Processes"},
											{:path => vendor_qualities_path, :name => "Quality ID"},
											{:path => specifications_path, :name => "Specifications"},
											{:path => commodities_path, :name => "Commodities"},
											{:path => territories_path, :name => "Territories"}
										]
		menus
	end


	def application_shortcuts
		[	{:name => "System", :class => "glyphicons cogwheels", :drop_down => true, :path => "#", 
				:sub_menu => [	
								{:path => company_infos_path, :name => "Company Info", :class => "", :drop_down => false, :sub_menu => []},
								{:path => owners_path, :name => "Owners", :class => "", :drop_down => false, :sub_menu => []},
								{:path => materials_path, :name => "Materials", :class => "", :drop_down => false, :sub_menu => []},
								{:path => process_types_path, :name => "Processes", :class => "", :drop_down => false, :sub_menu => []},
								{:path => vendor_qualities_path, :name => "Quality ID", :class => "", :drop_down => false, :sub_menu => []},
								{:path => customer_qualities_path, :name => "Quality Level", :class => "", :drop_down => false, :sub_menu => []},
								{:path => specifications_path, :name => "Specifications", :class => "", :drop_down => false, :sub_menu => []},
								{:path => commodities_path, :name => "Commodities", :class => "", :drop_down => false, :sub_menu => []},
								{:path => territories_path, :name => "Territories", :class => "", :drop_down => false, :sub_menu => []}
							]					
			}
		]		
	end

end