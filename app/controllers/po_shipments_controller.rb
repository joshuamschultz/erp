class PoShipmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  # GET /po_shipments
  # GET /po_shipments.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if params[:type] == "shipping"
            @po_lines = PoLine.where(:po_line_status => "open").includes(:po_header).select{|po_line|
                po_line = po_line_data_list(po_line, false)
                po_line[:po_line_shipping] = "<div class='po_line_shipping_input'><input po_line_id='#{po_line.id}' class='shipping_input_field shipping_input_po_#{po_line.po_header.id}' type='text' value='0'></div>"
                po_line[:po_line_shelf] = "<div class='po_line_shelf_input'><input type='text'></div>"
                po_line[:po_line_unit] =  "<div class='po_line_unit_input'><input type='text'></div>"
                po_line[:links] = "<a po_line_id='#{po_line.id}' class='btn_save_shipped btn-action glyphicons check btn-success' href='#'><i></i></a> <div class='pull-right shipping_status'></div>"
                po_line[:po_identifier] += "<a onclick='process_all_open(#{po_line.po_header.id}, $(this)); return false' class='pull-right btn btn-small btn-success' href='#'>Receive All</a>"
            }
            render json: {:aaData => @po_lines}
        else
            @po_shipments = (params[:type] == "history") ? PoShipment.where(:id => PayablePoShipment.all.collect(&:po_shipment_id)) : PoShipment.where("id not in (?)", [0] + PayablePoShipment.all.collect(&:po_shipment_id))
            @po_shipments = @po_shipments.includes(:po_line).order(:po_line_id).select{|po_shipment|
                po_line = po_shipment.po_line
                po_shipment = po_line_data_list(po_shipment, true)
                po_shipment[:po_shipped_date] = po_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")
                po_shipment[:links] = CommonActions.object_crud_paths(nil, edit_po_shipment_path(po_shipment), nil)
                po_shipment[:item_part_no] = po_shipment.payable_checkbox(params[:type]) + po_shipment[:item_part_no]
            }
            render json: {:aaData => @po_shipments}
        end
      }
    end
  end

  def po_line_data_list(object, shipment)
      po_line = shipment ? object.po_line : object
      object[:po_identifier] = CommonActions.linkable(po_header_path(po_line.po_header), po_line.po_header.po_identifier)
      object[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
      object[:vendor_name] = (CommonActions.linkable(organization_path(po_line.po_header.organization), po_line.po_header.organization.organization_name) if po_line.po_header.organization) || ""
      object[:customer_name] = (CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) if po_line.organization) || ""
      object[:quality_level_name] = (CommonActions.linkable(customer_quality_path(po_line.organization.customer_quality), po_line.organization.customer_quality.quality_name) if po_line.organization && po_line.organization.customer_quality) || ""
      object[:quality_id_name] = (CommonActions.linkable(customer_quality_path(po_line.po_header.organization.vendor_quality), po_line.po_header.organization.vendor_quality.quality_name) if po_line.po_header.organization && po_line.po_header.organization.vendor_quality) || ""
      object[:po_line_quantity] = po_line.po_line_quantity      
      object[:po_line_quantity_shipped] = "<div class='po_line_shipping_total'>#{po_line.po_line_shipped}</div>"
      object[:po_line_quantity_open] = "<div class='po_line_quantity_open'>#{po_line.po_line_quantity - po_line.po_line_shipped}</div>"
      object
  end

  # GET /po_shipments/1
  # GET /po_shipments/1.json
  def show
    @po_shipment = PoShipment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @po_shipment }
    end
  end

  # GET /po_shipments/new
  # GET /po_shipments/new.json
  def new
    @po_shipment = PoShipment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @po_shipment }
    end
  end

  # GET /po_shipments/1/edit
  def edit
    @po_shipment = PoShipment.find(params[:id])
  end

  # POST /po_shipments
  # POST /po_shipments.json
  def create
    @po_shipment = PoShipment.new(params[:po_shipment])

    # respond_to do |format|
    #   if @po_shipment.save
    #     format.html { redirect_to @po_shipment, notice: 'Po shipment was successfully created.' }
    #     format.json { render json: @po_shipment, status: :created, location: @po_shipment }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @po_shipment.errors, status: :unprocessable_entity }
    #   end
    # end

    respond_to do |format|
      if @po_shipment.save
        @po_shipment["quantity_open"] = @po_shipment.po_line.po_line_quantity - @po_shipment.po_line.po_line_shipped
        @po_shipment["shipped_status"] = @po_shipment.po_line.po_line_status
        format.html { redirect_to @po_shipment, notice: 'PO received was successfully created.' }
        format.json { render json: @po_shipment, status: :created, location: @po_shipment }
      else
        format.html { render action: "new" }
        format.json { render json: {errors:  @po_shipment.errors.first} }
      end
    end

  end

  # PUT /po_shipments/1
  # PUT /po_shipments/1.json
  def update
    @po_shipment = PoShipment.find(params[:id])

    respond_to do |format|
      if @po_shipment.update_attributes(params[:po_shipment])
        format.html { redirect_to po_shipments_path, notice: 'PO shipment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @po_shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /po_shipments/1
  # DELETE /po_shipments/1.json
  def destroy
    @po_shipment = PoShipment.find(params[:id])
    @po_shipment.destroy

    respond_to do |format|
      format.html { redirect_to po_shipments_url }
      format.json { head :no_content }
    end
  end
end
