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

	def self.get_quality_lot_div(soLineId)
		divdata = "<div class='so_line_lot_input'><select class='quality_lot' name='quality_lot_id' onchange='setLocation(this, #{soLineId})'>"
        if soLineId.present?
            # quality_lots = SoLine.find(soLineId).item.quality_lots.map { |x| (x && x.quantity_on_hand && x.quantity_on_hand > 0) ? [x.id,x.lot_control_no] : [] }
             so_line =  SoLine.find(soLineId)
             if so_line.item.present?
	            quality_lots = so_line.item.quality_lots.where('finished not in (?)', [true]).map { |x|  [x.id,x.lot_control_no]  }
	            quality_lots.each do |quality_lot|
	            	divdata += "<option value='#{quality_lot[0]}'>#{quality_lot[1]}</option>"
	            end
       		end
        end
		divdata += "</select></div>"
		divdata
	end
	def self.get_location_div(soLineId)
        if soLineId.present?
            # quality_lots = SoLine.find(soLineId).item.quality_lots.map { |x| (x && x.quantity_on_hand && x.quantity_on_hand > 0) ? [x.id,x.lot_control_no] : [] }
             so_line =  SoLine.find(soLineId)
             if so_line.item.present?
	            quality_lot = so_line.item.quality_lots.where('finished not in (?)', [true]).first
	            po_shipment = quality_lot.po_shipment if quality_lot
      			location = po_shipment.nil? ? "-" : po_shipment.po_shipped_unit.to_s + " - " + po_shipment.po_shipped_shelf
				location_div =  "<div id='location_#{soLineId}'>#{location}</div>"
       		end
        end
		location_div
	end

    def self.check_boxes(val, chkId, funct)
   		"<input type='checkbox' id='#{chkId}'  value='#{val}' onclick='#{funct}' >"
    end


	def self.linkable(path, title, extras = {})
		"<a href='#{path}'>#{title}</a>"
	end


	def self.nil_or_blank(attribute)
		attribute.nil? || attribute.eql?("")
	end


	def self.update_gl_accounts_for_gl_entry(title, op, amount)
    	gl_account = GlAccount.where('gl_account_title' => title ).first
		if op == 'increment'
			gl_amount = gl_account.gl_account_amount + amount
		elsif op == 'decrement'
			gl_amount = gl_account.gl_account_amount - amount
		end
         gl_account.update_attributes(gl_account_amount: gl_amount )
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

		if  user_signed_in? &&  !current_user.is_customer? && !current_user.is_vendor?
			menus[:contacts] = {:class => "hasSubmenu glyphicons adress_book", :path => "#", :name => "Organizations", :type => "multiple"}
			menus[:contacts][:sub_menu] = 	[
				{:path => organizations_path, :name => "Companies"},
				{:path => contacts_path, :name => "Contacts"},
				{:path => groups_path, :name => "Group"},
			]
		end

		if  user_signed_in? &&  !current_user.is_logistics? && !current_user.is_quality?
			menus[:quotes] = {:class => "hasSubmenu glyphicons notes", :path => '#' , :name => "Quotes", :type => "multiple"}

			menus[:quotes][:sub_menu] = 	[]

			if can? :view, Quote
				menus[:quotes][:sub_menu].push({:path => quotes_path, :name => "Vendor Quotes"})
			end

			if can? :view, CustomerQuote
				menus[:quotes][:sub_menu].push({:path => customer_quotes_path, :name => "Customer Quotes"})
			end

		end

    if  user_signed_in? && !current_user.is_customer?
			menus[:purchases] = {:class => "hasSubmenu glyphicons cart_in", :path => "#", :name => "Purchases", :type => "multiple"}
			menus[:purchases][:sub_menu] = 	[
				{:path => po_headers_path, :name => "Purchase Orders"}
			]
		end

		if  user_signed_in? && !current_user.is_vendor?
			menus[:sales] = {:class => "hasSubmenu glyphicons stats", :path => "#", :name => "Sales", :type => "multiple"}
			menus[:sales][:sub_menu] = 		[
				{:path => so_headers_path, :name => "Sales Orders"}
			]
		end

		menus[:inventory] = {:class => "hasSubmenu glyphicons cargo", :path => "#", :name => "Inventory", :type => "multiple"}
		menus[:inventory][:sub_menu] = 	[
			{:path => items_path, :name => "Items"},
			{:path => item_alt_names_path, :name => "Alternates"},
			{:path => inventory_adjustments_path, :name => "Adjust Inventory"},
			{:path => prints_path, :name => "Prints"},
			{:path => elements_path, :name => "Elements"}
		]

		if can? :view, Material
			menus[:inventory][:sub_menu].push({:path => materials_path, :name => "Materials"})
		end

		if can? :view, ProcessType
			menus[:inventory][:sub_menu].push({:path => process_types_path, :name => "Processes"})
		end
		if can? :view, Specification
			menus[:inventory][:sub_menu].push({:path => specifications_path, :name => "Specifications"})
		end

		if  user_signed_in? &&  !current_user.is_logistics? && !current_user.is_quality? && !current_user.is_customer? && !current_user.is_vendor?
			menus[:accounts] = {:class => "hasSubmenu glyphicons book", :path => "#", :name => "Accounts", :type => "multiple"}
			menus[:accounts][:sub_menu] = 	[
				{:path => payables_path, :name => "Payables"},
				{:path => payments_path, :name => "Payments"},
				{:path => receivables_path, :name => "Invoice"},
				{:path => receipts_path, :name => "Receipts"}
			]
		end

		if  user_signed_in? && !current_user.is_customer?
			menus[:general_ledger] = {:class => "hasSubmenu glyphicons book_open", :path => "#", :name => "General Ledger", :type => "multiple"}
			menus[:general_ledger][:sub_menu] = 	[]

        if can? :view, GlEntry
          menus[:general_ledger][:sub_menu].push({:path => new_gl_entry_path, :name => "Journal Entries"})
        end

        menus[:general_ledger][:sub_menu].push({:path => check_registers_path, :name => "Check Register"})
        menus[:general_ledger][:sub_menu].push({:path => credit_registers_path, :name => "Credit Register"})

        if can? :view, Reconcile
          menus[:general_ledger][:sub_menu].push({:path => reconciles_path, :name => "Reconcile"},)
        end

        if can? :view, GlAccount
          menus[:general_ledger][:sub_menu].push({:path => gl_accounts_path, :name => "Accounts"})
        end

        menus[:general_ledger][:sub_menu].push({:path => gl_types_path, :name => "Account Types"})

      end


		menus[:quality] = {:class => "hasSubmenu glyphicons log_book", :path => "#", :name => "Quality", :type => "multiple"}

  		menus[:quality][:sub_menu] = 	[]

  		if can? :view, QualityLot
  			menus[:quality][:sub_menu].push({:path => quality_lots_path, :name => "Lot Info"})
  		end

  		menus[:quality][:sub_menu].push({:path => process_flows_path, :name => "Process Flow"})
  		menus[:quality][:sub_menu].push({:path => fmea_types_path, :name => "FMEA"})
  		menus[:quality][:sub_menu].push({:path => control_plans_path, :name => "Control Plan"})
      menus[:quality][:sub_menu].push({:path => capacity_plannings_path, :name => "Capacity Planning"})

  		if can? :view, Package
  			menus[:quality][:sub_menu].push({:path => packages_path, :name => "Packaging"})
  		end

  		if can? :view, RunAtRate
  			menus[:quality][:sub_menu].push({:path => run_at_rates_path, :name => "Run at Rate"})
  		end

      menus[:quality][:sub_menu].push({:path => quality_actions_path, :name => "Quality Action"})

  		if can? :view, CauseAnalysis
  			menus[:quality][:sub_menu].push({:path => cause_analyses_path, :name => "Cause Analysis"})
  		end

  		if can? :view, CustomerFeedback
  			menus[:quality][:sub_menu].push({:path => customer_feedbacks_path, :name => "Customer Response"})
  		end

  		if can? :view, Gauge
  			menus[:quality][:sub_menu].push({:path => gauges_path, :name => "Instruments"})
  		end

      if can? :view, Dimension
        menus[:quality][:sub_menu].push({:path => dimensions_path, :name => "Dimension Types"})
    	end

      if  user_signed_in? && !current_user.is_vendor? && !current_user.is_customer?
       menus[:quality][:sub_menu].push({:path => customer_qualities_path, :name => "Quality Level"})
      end

      menus[:quality][:sub_menu].push({:path => vendor_qualities_path, :name => "Quality ID"})

		if  user_signed_in? && !current_user.is_vendor?  && !current_user.is_customer?
			menus[:logistics] = {:class => "hasSubmenu glyphicons boat", :path => "#", :name => "Logistics", :type => "multiple"}
			menus[:logistics][:sub_menu] = 	[
				{:path => new_po_shipment_path, :name => "Receiving"},
				{:path => new_so_shipment_path, :name => "Shipping"},
				{:path => so_shipments_path(type: "process"), :name => "In Process"},
				{:path => po_shipments_path(type: "history"), :name => "History"}
			]
		end

		menus[:reports] = {:class => "hasSubmenu glyphicons charts", :path => "#", :name => "Reports", :type => "multiple"}
		menus[:reports][:sub_menu] = 	[
			{:path => gauges_path(type: "gauge"), :name => "Gauge Calibration"},
			{:path => organizations_path(type1: "vendor",type2: "certification"), :name => "Vendor Qualification"},
			{:path => new_so_shipment_path(type1: "shipping_to",type2: "due_date"), :name => "Shipping Due"},
			{:path => quality_lots_path(type: "lot_missing_location"), :name => "Lots Missing Location"}

		]

		menus[:documentation] = {:class => "hasSubmenu glyphicons briefcase", :path => "#", :name => "Documentation", :type => "multiple"}
		menus[:documentation][:sub_menu] = 	[
			{:path => "#", :name => "Internal"},
			{:path => "#", :name => "Vendor"},
			{:path => "#", :name => "Customer"},
			{:path => "#", :name => "General"},
			{:path => quality_documents_path, :name => "Quality Level Documents"}


		]

		menus[:system] = {:class => "hasSubmenu glyphicons cogwheels", :path => "#", :name => "System", :type => "multiple"}

		menus[:system][:sub_menu] = 	[]

      menus[:system][:sub_menu].push({:path => events_path, :name => "Calendar"})

      menus[:system][:sub_menu].push({:path => commodities_path, :name => "Commodities"})


  		if can? :view, Territory
  			menus[:system][:sub_menu].push({:path => territories_path, :name => "Territories"})
  		end

  		if can? :view, Owner
  			menus[:system][:sub_menu].push({:path => owners_path, :name => "Owners"})
  		end

      menus[:system][:sub_menu].push({:path => check_code_path(CheckCode.first), :name => "Counters"})

  		if can? :view, User
  			menus[:system][:sub_menu].push({:path => privileges_path, :name => "Privileges"})
  		end

  		if can? :view, CompanyInfo
  			menus[:system][:sub_menu].push({:path => company_infos_path, :name => "Home Info"})
  		end

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


	def self.get_new_identifier(model, field, letter)
		max_identifier = model.maximum(field)
		if max_identifier.nil?
			letter + "00001"
		elsif (cur_identifier = max_identifier[1..5].to_i + 1) > 99999
			letter + "00001"
		else
			letter + "%05d" % cur_identifier
		end
	end

	def self.highlighted_text(string)
		"<div style='color:red'>#{string}</div>".html_safe
	end

	def self.status_color(status)
		if status == "won"
			"<div style='color:green'>#{status.capitalize}</div>".html_safe
		elsif status == "lost"
			"<div style='color:red'>#{status.capitalize}</div>".html_safe
		elsif status == "open"
			"<div>#{status.capitalize}</div>".html_safe
		end

	end

	def self.set_quality_status(status)
		if status == "open"
			"<div style='color:yellow'>#{status.capitalize}</div>".html_safe
		elsif status == "finished"
			"<div style='color:green'>#{status.capitalize}</div>".html_safe
		end
	end

	def self.process_application_notifications(user_id)
		temp = source = ''
		user = User.find(user_id)
		quality_user = User.where(:roles_mask => 4).first
		user.quality_actions.each do |quality_action|
			notification = notification_check_status(quality_action,"QualityAction",user)
			if notification.present?
				temp = "<li id="+notification.first.id.to_s+"><a href='/quality_actions/"+quality_action.id.to_s+"' class='glyphicons envelope'><i></i>"+quality_action.quality_action_no.to_s+"-Quality Action Assigned to you </a></li>"
				source += temp
			end
		end

		if User.current_user.present? && User.current_user.is_quality?
		 	vendor_organizations = Organization.where("vendor_expiration_date >= ? AND vendor_expiration_date <= ? AND organization_type_id = ?",Date.today, Date.today+29, 6)
		 	vendor_organizations.each do |vendor_organization|
		 		if vendor_organization.present?
		 			notification = notification_check_status(vendor_organization,"Organization",quality_user)
		 			if notification.present?
		 				temp = "<li id="+notification.first.id.to_s+"><a href='/organizations/"+vendor_organization.id.to_s+"' class='glyphicons envelope'><i></i>Certifications are about to expire</a></li>"
						source += temp
					end
		 		end
		 	end

		 	prints = Print.all
		 	prints.each do |print|
		 		if print.present?
		 			notification = notification_check_status(print,"Print",quality_user)
		 			if notification.present?
		 				temp = "<li id="+notification.first.id.to_s+"><a href='/prints/"+print.id.to_s+"' class='glyphicons envelope'><i></i>"+print.print_identifier+"-print created</a></li>"
						source += temp
					end
		 		end
		 	end

		 	specifications = Specification.all
		 	specifications.each do |specification|
		 		if specification.present?
		 			notification = notification_check_status(specification,"Specification",quality_user)
		 			if notification.present?
		 				temp = "<li id="+notification.first.id.to_s+"><a href='/specifications/"+specification.id.to_s+"' class='glyphicons envelope'><i></i>"+specification.specification_identifier+"-specification created</a></li>"
						source += temp
					end
		 		end
		 	end

		 	process_types = ProcessType.all
		 	process_types.each do |process_type|
		 		if process_type.present?
		 			notification = notification_check_status(process_type,"ProcessType",quality_user)
		 			if notification.present?
		 				temp = "<li id="+notification.first.id.to_s+"><a href='/process_types/"+process_type.id.to_s+"' class='glyphicons envelope'><i></i>"+process_type.process_short_name+"-process_type created</a></li>"
						source += temp
					end
		 		end
		 	end

		 	po_lines = PoLine.all
		 	po_lines.each do |po_line|
		 		if po_line.present?
		 			notification = notification_check_status(po_line,"PoLine",quality_user)
		 			if notification.present?
	 					temp = "<li id="+notification.first.id.to_s+"><a href='/po_headers/"+po_line.po_header.id.to_s+"' class='glyphicons envelope'><i></i>PO "+po_line.po_header.po_identifier+" bypassed supplier requirements</a></li>"
						source += temp
					end
		 		end
		 	end
		end

		source
	end

	def self.notification_check_status(note_id,note_type,u_id)
		if Notification.where(:notable_id => note_id.id).present?
			Notification.where("notable_id =? AND notable_type =? AND user_id =? AND note_status =? ", note_id.id, note_type, u_id.id, "unread")
		end
	end

	def self.notification_process(model_type, model_id)
		quality_user = User.where(:roles_mask => 4).first

      if model_type == "Organization" && model_id.organization_type_id == 6
      	common_process_model(model_type,model_id,quality_user)

      elsif model_type == "QualityAction"
      	if model_id.users.present?
            model_id.users.each do |user|
                notification_set_status(model_id,model_type,user.id)
            end
      	end

      elsif model_type == "Print"
     		common_process_model(model_type,model_id,quality_user)

      elsif model_type == "Specification"
    		common_process_model(model_type,model_id,quality_user)

      elsif model_type == "ProcessType"
     		common_process_model(model_type,model_id,quality_user)

     	elsif model_type == "PoLine"
     		if model_id.organization.present? && model_id.organization.min_vendor_quality.quality_name.ord <= model_id.po_header.organization.vendor_quality.quality_name.ord
     			common_process_model(model_type,model_id,quality_user)
     		end
      end
    end

    def self.common_process_model(model, model_note, user)
    	if user.present?
        	notification_set_status(model_note,model,user.id)
       	end
    end

    def self.notification_set_status(model_identifier,model_type_name,user_id)
    	notification = Notification.find_by_notable_id(model_identifier.id)
    	unless notification.present?
    		notification = Notification.create(notable_id: model_identifier.id, notable_type:  model_type_name, note_status:  "unread", user_id:  user_id)
    		notification.save
    	else
    		notification.update_attributes(:note_status => "unread")
    	end
    end


	def self.sales_report(so_id)
		@company_info = CompanyInfo.first 
		b_c_title = b_c_address_1 = b_c_address_2 = b_c_state = b_c_country = b_c_zipcode =''
		s_c_title = s_c_address_1 = s_c_address_2 = s_c_state = s_c_country = s_c_zipcode = ''
		item_part_no = item_alt_name = po_identifier  = item_description = ''
		so_line_quantity = so_line_shipped = source = so_line_notes=''
		content = cusomter_po = ''
		i,j,flag,flag2 = 1,1,1,1


		@so_header = SoHeader.find(so_id)

		if @so_header.bill_to_address.present?
			b_c_title = @so_header.bill_to_address.contact_title 
			b_c_address_1 = @so_header.bill_to_address.contact_address_1 
			b_c_address_2= @so_header.bill_to_address.contact_address_2
			b_c_state = @so_header.bill_to_address.contact_state 
			b_c_country = @so_header.bill_to_address.contact_country 
			b_c_zipcode = @so_header.bill_to_address.contact_zipcode 
		end
		if @so_header.ship_to_address.present?
			s_c_title = @so_header.ship_to_address.contact_title
			s_c_address_1= @so_header.ship_to_address.contact_address_1 
			s_c_address_2 = @so_header.ship_to_address.contact_address_2 
			s_c_state = @so_header.ship_to_address.contact_state 
			s_c_country = @so_header.ship_to_address.contact_country 
			s_c_zipcode = @so_header.ship_to_address.contact_zipcode 
		end
	

		cusomter_po =   @so_header.so_header_customer_po if @so_header.so_header_customer_po.present? 


		len = @so_header.so_lines.length

		@so_header.so_lines.each_with_index do |so_line, index|
			item_part_no = so_line.item.item_part_no
			item_alt_name = so_line.item.item_part_no != so_line.item_alt_name.item_alt_identifier ? so_line.item_alt_name.item_alt_identifier : ''
			item_description = so_line.item_revision.item_description if so_line.item_revision.present?
			so_line_notes = so_line.so_line_notes if so_line.so_line_notes.present?
			if i== 1  
				content += '<div class="ms_wrapper"><section><article><div class="ms_image"><img alt=Report_heading src=http://erp.chessgroupinc.com/'+@company_info.logo.joint.url(:original)+' /></div><div class="ms_image-2"><h3> Sales Order Number </h3><h2>'+@so_header.so_identifier+'</h2><h5>Sales Order Date :'+@so_header.created_at.strftime("%m/%d/%Y")+'</h5><h5> Customer P.O:'+cusomter_po+'</h5></div></article>'
				if flag ==1
					content += '<article><div class="ms_text"><h1 class="ms_heading">Bill To :</h1> <h2 class="ms_sub-heading">'+b_c_title+'</h2> <strong>'+b_c_address_1+'</strong> <strong>'+b_c_address_2+'</strong><strong>'+b_c_state+'</strong><strong>'+b_c_country+'&nbsp;'+b_c_zipcode+'</strong></div><div class="ms_text-2"><h1 class="ms_heading">Ship To : </h1> <h2 class="ms_sub-heading">'+s_c_title+'</h2> <strong>'+s_c_address_1+'</strong> <strong>'+s_c_address_2+'</strong><strong>'+s_c_state+'</strong><strong>'+s_c_country+'&nbsp; '+s_c_zipcode+'</strong></div></article>' 
					flag =0;
				end

				if flag2 ==1
					content += '<article class="art-01 art-04 de"><div class="ff"><table border="0" width="640px" cellspacing="0" cellpadding="0"><tbody><tr align="center" class="hea art-002"><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">CUST P/N - ALL P/N</td><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">Description</td><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">QTY</td><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">Shipped</td></tr></tbody></table></div>'
					flag2=0;
				else
					content += '<article class="art-01 art-04 de sal_tab2"><div class="ff"><table border="0" width="640px" cellspacing="0" cellpadding="0"><tbody><tr align="center" class="hea art-002"><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">CUST P/N - ALL P/N</td><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">Description</td><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">QTY</td><td style="font-weight: bold; padding:0 0 20px 0; font-size:16px;">Shipped</td></tr></tbody></table></div>'
				end
			end
			content += '<div class="fff"><table border="0" width="640px" cellspacing="0" cellpadding="0"><tbody><tr align="center" class="hea art-002"><td><table border="0" width="100%"><tbody><tr><td width="150" scope="row">'+item_part_no+'</td></tr> <tr><td width="150" scope="row">'+item_alt_name+'</td></tr> </tbody></table></td><td><table border="0" width="100%"><tbody><tr><td width="150" scope="row">'+item_description+'</td></tr>   </tbody></table></td><td >'+(so_line.so_line_quantity).to_s+'</td><td>'+so_line.so_line_shipped.to_s+'</td></tr><tr><td class="ww-01" style="color: #800000;">'+so_line_notes+' &nbsp </td></tr></tbody></table></div>'

			if i==4
				content += ' </article><article><div class="footer"><div class="page"><h3>Page </h3><h4>'+j.to_s+'</h4></div><div class="page-center">  <h3>'+@so_header.so_notes+'</h3></div><div class="original"><h3>Original </h3><h4><span>$</span>'+(@so_header.so_total.to_f).to_s+'</h4></div></article></section></div><div style="page-break-after:always;"></div>'
			end

			if len == index+1 && i != 4 
				# j = 1
				# j+=1
				content += ' </article><article><div class="footer"><div class="page"><h3>Page </h3><h4>'+j.to_s+'</h4></div><div class="page-center">  <h3>'+@so_header.so_notes+'</h3></div><div class="original"><h3>Original </h3><h4><span>$</span>'+(@so_header.so_total.to_f).to_s+'</h4></div></article></section></div>'
			end 

			i +=1 

			if i==5 
				j+=1
				i= 1
				content 
			end
		end
		content
		html = %'<!DOCTYPE html><title>Sales Report</title><style type="text/css">@charset "utf-8";body{font-family:Arial,Helvetica,sans-serif;font-size:14px}.clear{clear:both}.ms_wrapper{height:auto}.ms_wrapper section{float:left;height:auto;width:640px}.ms_wrapper .ms_heading{border-bottom:2px solid #999;font-size:16px;margin:30px 0 4px;padding:0 0 10px;width:100%}.ms_wrapper .ms_image{border:1px solid #ccc;float:left;font-size:22px;text-align:center;width:310px;height:85px;padding:25px 0}.ms_wrapper .ms_image-2{border:1px solid #ccc;float:right;font-size:22px;text-align:center;width:310px;height:135px}.ms_wrapper article{float:left;width:100%}.ms_wrapper .ms_text{float:left;font-size:15px;height:auto;line-height:23px;width:262px;margin:0;color:#666}.ms_wrapper .ms_offers{float:left;margin:12px 0 0;padding:10px 0 0;text-align:center}.ms_wrapper .ms_sub-heading{font-size:22px;margin:20px 0 6px;color:#000}.ms_text strong,.ms_text-2 strong{float:left;font-size:14px;font-weight:400;line-height:19px;width:100%}.ms_text1 strong{float:left;font-size:14px;line-height:19px;width:100%;margin:1px 0;text-align:center;font-weight:700}.ms_image-2 h3{color:navy;font-size:16px;font-weight:400;margin:17px 0 0;text-decoration:underline}.ms_image-2 h2{color:maroon;font-size:20px;font-weight:700;margin:2px 0}.ms_image-2 h5{font-size:16px;font-weight:700;margin:2px 0}.ms_text-3-wrapper{float:left;width:310px}.ms_text-3-wrapper .ms_text-3{width:152px;float:left}.ms_text-3-wrapper .ms_text-4{width:152px;float:right}.ms_text-3-wrapper .ms_text-4 strong{float:left;font-size:14px;font-weight:400;line-height:19px;width:100%;margin:6px 0;text-align:center}.ms_text-3-wrapper .ms_text-3 strong{color:maroon;float:left;font-size:14px;font-weight:400;line-height:19px;width:100%;margin:6px 0;text-align:center}.ms_text-3.text-5 strong{color:#000!important}.ms_text-3-wrapper .ms_sub-heading{font-size:16px;text-align:center;margin:30px 0 12px}.ms_sub{font-size:15px;text-align:center;text-decoration:underline;margin:2px 0 10px}.ms_text{border-bottom:2px solid #999;float:left;padding:0 0 16px;width:310px}.ms_text-2{border-bottom:2px solid #999;float:right;padding:0 0 16px;width:310px}.ms_text1{float:left;margin:12px 28px 0;width:42%}.ms_wrapper .ms_image2{margin:0 20px 0 0;border:1px solid #ccc;padding:20px 0;text-align:center;font-size:22px}.ms_image2 h2{font-size:17px;margin:0}.ms_image2 strong{color:maroon;float:left;font-size:22px;margin:0 0 8px;width:100%}.ms_image2 p{font-size:18px;margin:0;color:navy}.footer{width:630px;border:2px solid #444;float:left;margin:0 0 10px}.page{float:left;margin:0 0 0 20px}.page h3{font-size:14px;font-weight:700;margin:12px 0 0}.page h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.original{float:right;margin:0 20px 0 0}.original h3{font-size:14px;font-weight:700;margin:12px 0 0}.original h4{color:maroon;font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.original h4 span{color:#000;margin:0 4px 0 0}.page-center{float:left;text-align:center;width:411px}.page-center h3{color:maroon;font-size:14px;font-weight:700;margin:12px 0 0}.page-center h4{font-size:12px;font-weight:400;margin:5px 0 12px;text-align:center}.text-6{color:maroon;margin:0 14px 0 0!important;width:auto!important}.text-7{float:left;margin:22px 0 0;width:100%}.ms_image img{width:196px}.h-pad>td{font-size:14px;margin:30px 0 12px;padding:0;text-align:center;width:90px}.hea.art-002>td{float:left;font-size:14px;padding:3px 0;text-align:center;width:159px}.ww-01{border-bottom:1px solid #000;text-align:center;padding:2px 0}.de{margin:35px 0 0;min-height:410px}.sal_tab2{height:600px}</style>#{content}'
	end
end