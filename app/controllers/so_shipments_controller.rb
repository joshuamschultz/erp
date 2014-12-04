class SoShipmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :set_page_info

  def set_page_info
      @menus[:logistics][:active] = "active"
  end

  # GET /so_shipments
  # GET /so_shipments.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if(params[:type] == "shipping")
            @so_lines = SoLine.where(:so_line_status => "open").select{|so_line|
                so_line = so_line_data_list(so_line, false)
                so_line[:so_due_date]= so_line.so_header.so_due_date ? so_line.so_header.so_due_date.strftime("%m-%d-%Y") : ""
                so_line[:so_line_shipping] = "<div class='so_line_shipping_input'><input so_line_id='#{so_line.id}' so_shipped_status='shipped' class='shipping_input_field shipping_input_so_#{so_line.so_header.id}' type='text' value='0'></div>"
                so_line[:so_line_lot]= CommonActions.get_quality_lot_div(so_line.id)
                so_line[:so_line_shelf] = "<div class='so_line_shelf_input'><input type='text'></div>"
                so_line[:so_line_unit] =  "<div class='so_line_unit_input'><input type='text'></div>"
                so_line[:so_identifier] += "<a onclick='process_all_open(#{so_line.so_header.id}, $(this)); return false' class='pull-right btn btn-small btn-success' href='#'>Ship All</a>"
                so_line[:so_identifier] += "<a onclick='fill_po_items(#{so_line.so_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Fill</a>"
                so_line[:links] = "<a so_line_id='#{so_line.id}' so_shipped_status='shipped' class='btn_save_shipped btn-action glyphicons check btn-success' href='#'><i></i></a> <div class='pull-right shipping_status'></div>"
            }
            render json: {:aaData => @so_lines}
        else
            @item = Item.find(params[:item_id]) if params[:item_id].present?

            if @item
                @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(@item.so_shipments).order("created_at desc") : SoShipment.open_shipments(@item.so_shipments).order("created_at desc")
            else
                @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(nil).order("created_at desc") : SoShipment.open_shipments(nil).order("created_at desc")
            end
            i = 0
            @so_shipments = @so_shipments.includes(:so_line).order(:so_line_id).select{|so_shipment|
                so_shipment[:index] =  i
                so_shipment = so_line_data_list(so_shipment, true)   
                so_shipment[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, edit_so_shipment_path(so_shipment), nil)
                so_shipment[:so_shipped_date] = so_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")
                so_shipment[:item_part_no] = params[:create_receivable] ? so_shipment.receivable_checkbox(params[:type]) + so_shipment[:item_part_no] : so_shipment[:item_part_no]
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
    object[:item_part_no] = CommonActions.linkable(item_path(so_line.item), so_line.item_alt_name.item_alt_identifier)
    object[:customer_name] = so_line.so_header.organization ? CommonActions.linkable(organization_path(so_line.so_header.organization), so_line.so_header.organization.organization_name) : ""
    object[:vendor_name] = so_line.organization ? CommonActions.linkable(organization_path(so_line.organization), so_line.organization.organization_name) : "CHESS"
    object[:lot] = "" 
    
      if shipment && object.quality_lot_id && object.quality_lot_id > 0
        quality_lot = QualityLot.find(object.quality_lot_id)
        object[:lot] =quality_lot.lot_control_no.split('-')[0]+"-"+"<a href='/quality_lots/#{quality_lot.id}'>#{quality_lot.lot_control_no.split('-')[1]}</a>"
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
