class SoShipmentsController < ApplicationController
  # GET /so_shipments
  # GET /so_shipments.json
  def index
    @so_shipments = SoShipment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {:aaData => @so_shipments} }
    end
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
        format.html { redirect_to @so_shipment, notice: 'So shipment was successfully created.' }
        format.json { render json: @so_shipment, status: :created, location: @so_shipment }
      else
        format.html { render action: "new" }
        format.json { render json: @so_shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /so_shipments/1
  # PUT /so_shipments/1.json
  def update
    @so_shipment = SoShipment.find(params[:id])

    respond_to do |format|
      if @so_shipment.update_attributes(params[:so_shipment])
        format.html { redirect_to @so_shipment, notice: 'So shipment was successfully updated.' }
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
