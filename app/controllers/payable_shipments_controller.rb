class PayableShipmentsController < ApplicationController
  # GET payables/1/payable_shipments
  # GET payables/1/payable_shipments.json
  def index
    @payable = Payable.find(params[:payable_id])
    @payable_shipments = @payable.payable_shipments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @payable_shipments }
    end
  end

  # GET payables/1/payable_shipments/1
  # GET payables/1/payable_shipments/1.json
  def show
    @payable = Payable.find(params[:payable_id])
    @payable_shipment = @payable.payable_shipments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payable_shipment }
    end
  end

  # GET payables/1/payable_shipments/new
  # GET payables/1/payable_shipments/new.json
  def new
    @payable = Payable.find(params[:payable_id])
    @payable_shipment = @payable.payable_shipments.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payable_shipment }
    end
  end

  # GET payables/1/payable_shipments/1/edit
  def edit
    @payable = Payable.find(params[:payable_id])
    @payable_shipment = @payable.payable_shipments.find(params[:id])
  end

  # POST payables/1/payable_shipments
  # POST payables/1/payable_shipments.json
  def create
    @payable = Payable.find(params[:payable_id])
    @payable_shipment = @payable.payable_shipments.build(params[:payable_shipment])

    respond_to do |format|
      if @payable_shipment.save
        format.html { redirect_to([@payable_shipment.payable, @payable_shipment], :notice => 'Payable shipment was successfully created.') }
        format.json { render :json => @payable_shipment, :status => :created, :location => [@payable_shipment.payable, @payable_shipment] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payable_shipment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT payables/1/payable_shipments/1
  # PUT payables/1/payable_shipments/1.json
  def update
    @payable = Payable.find(params[:payable_id])
    @payable_shipment = @payable.payable_shipments.find(params[:id])

    respond_to do |format|
      if @payable_shipment.update_attributes(params[:payable_shipment])
        format.html { redirect_to([@payable_shipment.payable, @payable_shipment], :notice => 'Payable shipment was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payable_shipment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE payables/1/payable_shipments/1
  # DELETE payables/1/payable_shipments/1.json
  def destroy
    @payable = Payable.find(params[:payable_id])
    @payable_shipment = @payable.payable_shipments.find(params[:id])
    @payable_shipment.destroy

    respond_to do |format|
      format.html { redirect_to payable_payable_shipments_url(payable) }
      format.json { head :ok }
    end
  end
end
