class PoShipmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :set_page_info

  def set_page_info
      @menus[:logistics][:active] = "active"
  end

  # GET /po_shipments
  # GET /po_shipments.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if params[:type] == "shipping"
            @po_lines = PoLine.where(:po_line_status => "open").includes(:po_header).select{|po_line|
                po_line = po_line.po_line_data_list(po_line, false)
             }
            render json: {:aaData => @po_lines}
        else
            @item = Item.find(params[:item_id]) if params[:item_id].present?
            if @item
                @po_shipments = (params[:type] == "history") ? PoShipment.closed_shipments(@item.po_shipments).order("created_at desc") : PoShipment.open_shipments(@item.po_shipments).order("created_at desc")
            else
                @po_shipments = (params[:type] == "history") ? PoShipment.closed_shipments(nil).order("created_at desc") : PoShipment.open_shipments(nil).order("created_at desc")
            end
            i = 0
            @po_shipments = @po_shipments.includes(:po_line).order(:po_line_id).select{|po_shipment|
                po_shipment[:index] =  i
                po_shipment = po_shipment.po_line.po_line_data_list(po_shipment, true)
                po_shipment[:po_shipped_date] = po_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")
                po_shipment[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, edit_po_shipment_path(po_shipment), nil)
                po_shipment[:item_part_no] = (params[:create_payable].present? ? po_shipment.payable_checkbox(params[:type]) : "") + po_shipment[:item_part_no]
                i += 1
            }
            render json: {:aaData => @po_shipments}
        end
      }
    end
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
