class SoShipmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :set_page_info
  before_filter :view_permissions, except: [:new]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_operations? || current_user.is_clerical? )
        authorize! :edit, SoShipment
    end 
  end

  def user_permissions
   if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer?  )
        authorize! :edit, SoShipment
    end 
  end

  def set_page_info
    unless user_signed_in? && (current_user.is_vendor? || current_user.is_customer?  )
      unless params[:type1].present? && params[:type2].present? 
        @menus[:logistics][:active] = "active"
      else
        @menus[:reports][:active] = "active" 
      end
    end
  end

  # GET /so_shipments
  # GET /so_shipments.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if(params[:type] == "shipping")
            @so_lines =   SoLine.where(:so_line_status => "open").joins(:so_header).order("so_headers.so_due_date ASC").select{|so_line|
              so_line = so_line_data_list(so_line, false)

                                so_line[:so_due_date]= so_line.so_header.so_due_date ? so_line.so_header.so_due_date.strftime("%m-%d-%Y") : ""
                so_line[:so_line_shipping] = "<div class='so_line_shipping_input'><input so_line_id='#{so_line.id}' so_shipped_status='process' class='shipping_input_field shipping_input_so_#{so_line.so_header.id}' type='text' value='0'></div>"
                so_line[:so_line_lot]= CommonActions.get_quality_lot_div(so_line.id)                
                so_line[:so_line_location] = CommonActions.get_location_div(so_line.id)
                if can? :edit, SoShipment

                  so_line[:so_identifier] += "<a onclick='process_all_open(#{so_line.so_header.id}, $(this)); return false' class='pull-right btn btn-small btn-success' href='#'>Ship All</a>"
                  so_line[:so_identifier] += "<a onclick='fill_po_items(#{so_line.so_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Fill</a>"
                  # so_line[:so_identifier] += "<a onclick='shipment_process(#{so_line.so_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Complete Shipment</a>"
                  so_line[:links] = "<a onclick='item_locations(#{so_line.item.id}); return false' class='btn-action glyphicons eye_open btn-default' data-toggle='modal' href='#modal-simple'><i></i></a>"
                  so_line[:links] += "<a so_line_id='#{so_line.id}' so_shipped_status='process' class='btn_save_shipped btn-action glyphicons check btn-success' href='#'><i></i></a> <div class='pull-right shipping_status'></div>"
                  so_line[:links] += "<a so_line_id='#{so_line.id}' so_shipped_status='ship_close' class='btn_save_shipped_close btn-action   btn-success' href='#'>Close</a>"
                else
                  so_line[:so_identifier] += ""
                  so_line[:so_identifier] += ""
                  so_line[:links] = ""

                end 
            }
            render json: {:aaData => @so_lines}
        elsif params[:type1].present? && params[:type2].present?
             @so_lines = SoLine.where(:so_line_status => "open").joins(:so_header).where("so_headers.so_due_date >= ? AND so_headers.so_due_date <= ?", Date.today, Date.today+6).select{|so_line|
                

                so_line = so_line_data_list(so_line, false)

                                so_line[:so_due_date]= so_line.so_header.so_due_date ? so_line.so_header.so_due_date.strftime("%m-%d-%Y") : ""
                so_line[:so_line_shipping] = "<div class='so_line_shipping_input'><input so_line_id='#{so_line.id}' so_shipped_status='shipped' class='shipping_input_field shipping_input_so_#{so_line.so_header.id}' type='text' value='0'></div>"
              
            }
            render json: {:aaData => @so_lines}
        else
            @item = Item.find(params[:item_id]) if params[:item_id].present?
            @quality_lot = QualityLot.find(params[:quality_lot_id]) if params[:quality_lot_id].present?

            if @item
                if params[:type].present?
                  @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(@item.so_shipments).order("created_at desc") : SoShipment.open_shipments(@item.so_shipments).order("created_at desc")
                else
                  @so_shipments = SoShipment.all_shipments(@item.id)
                end  
            elsif  @quality_lot
                  if params[:type].present?
                    @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(@quality_lot.so_shipments).order("created_at desc") : SoShipment.open_shipments(@quality_lot.so_shipments).order("created_at desc")
                  else     
                    @so_shipments = @quality_lot.so_shipments.where(:so_shipped_status => "shipped")  
                  end

            else
                @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(nil).order("created_at desc") : SoShipment.open_shipments(nil).order("created_at desc").where(:so_shipped_status => ["shipped"])
                if params[:type] == "process"
                  @so_shipments =  SoShipment.open_shipments(nil).order("created_at desc").where(:so_shipped_status => ["process", "ship_close"])
                end

            end
            i = 0
            @so_shipments = @so_shipments.includes(:so_line).order(:so_line_id).select{|so_shipment|
                

                so_shipment[:index] =  i
                so_shipment = so_line_data_list(so_shipment, true) 
                if params[:type] == "process"
                  ship_id = '"'+so_shipment.shipment_process_id+'"'
                  so_shipment[:shipment_process_id] = so_shipment.shipment_process_id
                  so_shipment[:shipment_process_id] += "<a onclick='shipment_process(#{ship_id}); return false' class='pull-right btn btn-small btn-success' href='#'>Complete Shipment</a>"
                end
                if can? :edit, SoShipment  
                  so_shipment[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, edit_so_shipment_path(so_shipment), nil)
                else
                  so_shipment[:links] = ""
                end
                so_shipment[:so_shipped_date] = so_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")
                if params[:type] == "process"
                  so_shipment[:item_part_no] = params[:create_receivable] ?  so_shipment[:item_part_no] : so_shipment[:item_part_no]
                else
                  so_shipment[:item_part_no] = params[:create_receivable] ? so_shipment.receivable_checkbox(params[:type]) + so_shipment[:item_part_no] : so_shipment[:item_part_no]
                end
                i += 1
            }
            render json: {:aaData => @so_shipments}
        end
      }
    end
  end

  def so_line_data_list(object, shipment)
    so_line = shipment ? object.so_line : object


      object[:so_identifier] = CommonActions.linkable(so_header_path(so_line.so_header), so_line.so_header.so_identifier)    
      object[:item_part_no] = so_line.item.present? ?  CommonActions.linkable(item_path(so_line.item), so_line.item_alt_name.item_alt_identifier)   : ""
      object[:customer_name] = so_line.so_header.organization ? CommonActions.linkable(organization_path(so_line.so_header.organization), so_line.so_header.organization.organization_name) : ""
      object[:vendor_name] = so_line.organization ? CommonActions.linkable(organization_path(so_line.organization), so_line.organization.organization_name) : "CHESS"
      object[:customer_name] = so_line.organization ? CommonActions.linkable(organization_path(so_line.so_header.organization), so_line.so_header.organization.organization_name) : "CHESS"
    object[:lot] = "" 
    
      if shipment && object.quality_lot_id && object.quality_lot_id > 0
        quality_lot = QualityLot.find(object.quality_lot_id)        
        object[:lot] =quality_lot.lot_control_no.split('-')[0]+"-"+"<a href='/quality_lots/#{quality_lot.id}'>#{quality_lot.lot_control_no.split('-')[1]}</a>" if quality_lot.present? && quality_lot.lot_control_no.present?
      end
   
    # object[:quality_level_name] = CommonActions.linkable(customer_quality_path(so_line.customer_quality), so_line.customer_quality.quality_name)
    object[:so_line_quantity] = so_line.so_line_quantity
    object[:so_line_quantity_shipped] = "<div class='so_line_shipping_total'>#{so_line.so_line_shipped}</div>"    
    object[:so_line_quantity_open] = "<div class='so_line_quantity_open'>#{so_line.so_line_quantity - so_line.so_line_shipped}</div>" 
    object
  end

  # GET /so_shipments/1
  # GET /so_shipments/1.json
  def show
    @so_shipment = SoShipment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @so_shipment }
    end
  end

  # GET /so_shipments/new
  # GET /so_shipments/new.json
  def new
    @so_shipment = SoShipment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @so_shipment }
    end
  end

  # GET /so_shipments/1/edit
  def edit
    @so_shipment = SoShipment.find(params[:id])
  end

  # POST /so_shipments
  # POST /so_shipments.json
  def create
    @so_shipment = SoShipment.new(params[:so_shipment])

    respond_to do |format|
      if @so_shipment.save

        @so_shipment.set_quality_on_hand        
        @so_shipment.so_line.update_so_total
        @so_shipment["so"] = @so_shipment.so_line.so_header.so_identifier
        @so_shipment["so_total"] = @so_shipment.so_line.so_header.so_total.to_f
        if @so_shipment.so_line.so_header.bill_to_address.present? 
          @so_shipment["so_b_c_title"]= @so_shipment.so_line.so_header.bill_to_address.contact_title 
          @so_shipment["so_b_c_address_1"] = @so_shipment.so_line.so_header.bill_to_address.contact_address_1 
          @so_shipment["so_b_c_address_2"] = @so_shipment.so_line.so_header.bill_to_address.contact_address_2 
          @so_shipment["so_b_c_state"] = @so_shipment.so_line.so_header.bill_to_address.contact_state 
          @so_shipment["so_b_c_country"] = @so_shipment.so_line.so_header.bill_to_address.contact_country 
          @so_shipment["so_b_c_zipcode"] = @so_shipment.so_line.so_header.bill_to_address.contact_zipcode
        end 
        if @so_shipment.so_line.so_header.ship_to_address.present? 
          @so_shipment["so_s_c_title"]= @so_shipment.so_line.so_header.ship_to_address.contact_title 
          @so_shipment["so_s_c_address_1"] = @so_shipment.so_line.so_header.ship_to_address.contact_address_1 
          @so_shipment["so_s_c_address_2"] = @so_shipment.so_line.so_header.ship_to_address.contact_address_2 
          @so_shipment["so_s_c_state"] = @so_shipment.so_line.so_header.ship_to_address.contact_state 
          @so_shipment["so_s_c_country"] = @so_shipment.so_line.so_header.ship_to_address.contact_country 
          @so_shipment["so_s_c_zipcode"] = @so_shipment.so_line.so_header.ship_to_address.contact_zipcode
        end 
        @so_shipment["so_notes"] = @so_shipment.so_line.so_header.so_notes if @so_shipment.so_line.so_header.so_notes
        @so_shipment["so_date"] = "Sales Order Date :"+@so_shipment.so_line.so_header.created_at.strftime("%m/%d/%Y")
        @so_shipment["part_number"] = @so_shipment.so_line.item.item_part_no
        @so_shipment["part_desc"] = @so_shipment.so_line.item_revision.item_description.present? ? @so_shipment.so_line.item_revision.item_description : ''
        @so_shipment["alt_part_number"] = @so_shipment.so_line.item_alt_name.item_alt_identifier if @so_shipment.so_line.item.item_part_no != @so_shipment.so_line.item_alt_name.item_alt_identifier 
        @so_shipment["so_line_quantity"] = @so_shipment.so_line.so_line_quantity
        @so_shipment["control_number"] = @so_shipment.quality_lot.lot_control_no if @so_shipment.quality_lot
        @so_shipment["quantity_open"] = @so_shipment.so_line.so_line_quantity - @so_shipment.so_line.so_line_shipped
        @so_shipment["shipped_status"] = @so_shipment.so_line.so_line_status
        format.html { redirect_to @so_shipment, notice: 'SO shipment was successfully created.' }
        format.json { render json: @so_shipment, status: :created, location: @so_shipment }
      else
        format.html { render action: "new" }
        format.json { render json: {errors:  @so_shipment.errors.first} }
      end
    end
  end

  # PUT /so_shipments/1
  # PUT /so_shipments/1.json
  def update
    @so_shipment = SoShipment.find(params[:id])

    respond_to do |format|
      if @so_shipment.update_attributes(params[:so_shipment])
        # format.html { redirect_to @so_shipment, notice: 'So shipment was successfully updated.' }
        format.html { redirect_to so_shipments_path, notice: 'SO shipment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @so_shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /so_shipments/1
  # DELETE /so_shipments/1.json
  def destroy
    @so_shipment = SoShipment.find(params[:id])
    @so_shipment.destroy

    respond_to do |format|
      format.html { redirect_to so_shipments_url }
      format.json { head :no_content }
    end
  end

end
