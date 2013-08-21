class PoShipmentsController < ApplicationController
  # GET /po_shipments
  # GET /po_shipments.json
  def index
    @po_shipments = PoShipment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @po_shipments }
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
        format.html { redirect_to @po_shipment, notice: 'Po shipment was successfully created.' }
        format.json { render json: @po_shipment, status: :created, location: @po_shipment }
      else
        format.html { render action: "new" }
        format.json { render json: @po_shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /po_shipments/1
  # PUT /po_shipments/1.json
  def update
    @po_shipment = PoShipment.find(params[:id])

    respond_to do |format|
      if @po_shipment.update_attributes(params[:po_shipment])
        format.html { redirect_to @po_shipment, notice: 'Po shipment was successfully updated.' }
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
