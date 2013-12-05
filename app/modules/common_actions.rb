module CommonActions
	include Rails.application.routes.url_helpers

	def self.clear_temp_objects(params = {})
		PoHeader.where(po_identifier: UNASSIGNED).destroy_all
		SoHeader.where(so_identifier: UNASSIGNED).destroy_all
	end

	def self.object_crud_paths(show_path, edit_path, delete_path, others = [])
		paths = ""
		paths += "<a href='#{show_path}' class='btn-action glyphicons eye_open btn-default'><i></i></a> " if show_path
      	paths += "<a href='#{edit_path}' class='btn-action glyphicons pencil btn-success'><i></i></a> " if edit_path
      	paths += "<a href='#{delete_path}' class='btn-action glyphicons remove_2 btn-danger' rel='nofollow' data-method='delete' data-confirm='Are you sure?'><i></i></a> " if delete_path
		others.each do |other|
			unless other.nil?
				other[:method] ||= "get"
				paths += "<a href='#{other[:path]}' class='btn btn-mini btn-orange' data-method='#{other[:method]}'>#{other[:name]}</a> "
			end
		end
		paths
	end


	def self.linkable(path, title, extras = {})
		"<a href='#{path}'>#{title}</a>"
	end
	

	def self.nil_or_blank(attribute)
		attribute.nil? || attribute.eql?("")
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


	def self.record_ownership(record, current_user)
		if record.new_record?
			record.created_by = current_user
		else
			record.updated_by = current_user
		end
		record
	end


	def self.current_hour_letter
		hour_letter = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X"]
		hour_letter[Time.now.hour]
	end


  private


	def after_sign_in_path_for(user)
		account_dashboard_path
	end

	def initialize_request
		unless params[:controller] == "rails_admin/main"
			params[:layout] = params[:layout] == "false" ? false : true
			@home = {:name => CompanyInfo.first ? CompanyInfo.first.company_name : "Alliance Fasteners"}
			@menus = application_main_menu
			@shortcuts = application_shortcuts
		end
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
											{:path => organizations_path, :name => "Organizations"},
											{:path => contacts_path(org_type: "vendor", :contact_type => "contact"), :name => "Vendor"}, 
											{:path => contacts_path(org_type: "customer", :contact_type => "contact"), :name => "Customer"},
											{:path => contacts_path(org_type: "support", :contact_type => "contact"), :name => "Support"}
											
										]

		menus[:quotes] = {:class => "hasSubmenu glyphicons notes", :path => "#", :name => "Quotes", :type => "single"}
		# menus[:quotes][:sub_menu] = 	[
		# 									{:path => "#", :name => "Vendor"}, 
		# 									{:path => "#", :name => "Customer"}
		# 								]

		menus[:purchases] = {:class => "hasSubmenu glyphicons cart_in", :path => "#", :name => "Purchases", :type => "multiple"}
		menus[:purchases][:sub_menu] = 	[
											{:path => po_headers_path, :name => "Purchase Orders"}
										]		

		menus[:sales] = {:class => "hasSubmenu glyphicons stats", :path => "#", :name => "Sales", :type => "multiple"}
		menus[:sales][:sub_menu] = 		[
											{:path => so_headers_path, :name => "Sales Orders"}
										]

		menus[:inventory] = {:class => "hasSubmenu glyphicons cargo", :path => "#", :name => "Inventory", :type => "multiple"}
		menus[:inventory][:sub_menu] = 	[
											{:path => items_path, :name => "Items"},
											{:path => item_alt_names_path, :name => "Alt Names"},
											{:path => prints_path, :name => "Prints"},
											{:path => process_types_path, :name => "Processes"},
											{:path => specifications_path, :name => "Specifications"},
											{:path => materials_path, :name => "Materials"},
											{:path => elements_path, :name => "Elements"}
										]

		menus[:accounts] = {:class => "hasSubmenu glyphicons book", :path => "#", :name => "Accounts", :type => "multiple"}
		menus[:accounts][:sub_menu] = 	[											
											{:path => payables_path, :name => "Payables"},
											{:path => payments_path, :name => "Payments"},
											{:path => "#", :name => "Receivables"},
											{:path => "#", :name => "Receipts"}
										]
		
		menus[:general_ledger] = {:class => "hasSubmenu glyphicons book_open", :path => "#", :name => "General Ledger", :type => "multiple"}
		menus[:general_ledger][:sub_menu] = 	[
											{:path => "#", :name => "Journal Entries"}, 
											{:path => "#", :name => "Chart of Accounts"},
											{:path => "#", :name => "Reconcile"}
										]		

		menus[:quality] = {:class => "hasSubmenu glyphicons log_book", :path => "#", :name => "Quality", :type => "multiple"}
		menus[:quality][:sub_menu] = 	[
											{:path => "#", :name => "Checklist"}, 
											{:path => quality_lots_path, :name => "Lot Info"},
											# {:path => quality_lot_materials_path, :name => "Material"}, 
											# {:path => quality_lot_dimensions_path, :name => "Dimensions"}, 
											{:path => "#", :name => "Run at Rate"},
											{:path => "#", :name => "Part Submission Warrant"}, 
											{:path => "#", :name => "Packaging"},
											{:path => gauges_path, :name => "Instruments"},
											{:path => "#", :name => " Cause Analysis"}, 
											{:path => process_flows_path, :name => "Process Flow"},
											{:path => fmea_types_path, :name => "FMEA"},
											{:path => control_plans_path, :name => "Control Plan"},
											{:path => "#", :name => "Customer Response"},
											{:path => "#", :name => "Quality Action"},
											{:path => vendor_qualities_path, :name => "Quality ID"},
											{:path => customer_qualities_path, :name => "Quality Level"},
											{:path => dimensions_path, :name => "Dimension Types"}
										]
		
		# menus[:shipments] = {:class => "glyphicons boat", :path => new_po_shipment_path, :name => "Shipments", :type => "single"}
		
		menus[:logistics] = {:class => "hasSubmenu glyphicons briefcase", :path => "#", :name => "Logistics", :type => "multiple"}
		menus[:logistics][:sub_menu] = 	[
											{:path => new_po_shipment_path, :name => "Shipments"}, 
											{:path => po_shipments_path(type: "history"), :name => "History"}
										]

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
											{:path => company_infos_path, :name => "Home Info"},
											{:path => owners_path, :name => "Owners"},
											{:path => privileges_path, :name => "Privileges"},
											{:path => territories_path, :name => "Territories"},
											{:path => "#", :name => "Documents"},											
											{:path => commodities_path, :name => "Commodities"}
										]
		menus
	end


	def application_shortcuts
		[	{:name => "System", :class => "glyphicons cogwheels", :drop_down => true, :path => "#", 
				:sub_menu => [	
								{:path => company_infos_path, :name => "Company Info", :class => "", :drop_down => false, :sub_menu => []},
								{:path => owners_path, :name => "Owners", :class => "", :drop_down => false, :sub_menu => []},
								{:path => territories_path, :name => "Territories", :class => "", :drop_down => false, :sub_menu => []},
								{:path => commodities_path, :name => "Commodities", :class => "", :drop_down => false, :sub_menu => []}
								# {:path => specifications_path, :name => "Specifications", :class => "", :drop_down => false, :sub_menu => []},								
								# {:path => materials_path, :name => "Materials", :class => "", :drop_down => false, :sub_menu => []},
								# {:path => process_types_path, :name => "Processes", :class => "", :drop_down => false, :sub_menu => []},
								# {:path => vendor_qualities_path, :name => "Quality ID", :class => "", :drop_down => false, :sub_menu => []},
								# {:path => customer_qualities_path, :name => "Quality Level", :class => "", :drop_down => false, :sub_menu => []},
							]					
			}
		]		
	end

end