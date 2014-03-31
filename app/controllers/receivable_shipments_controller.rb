class ReceivableShipmentsController < ApplicationController
  # GET receivables/1/receivable_shipments
  # GET receivables/1/receivable_shipments.json
  def index
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipments = @receivable.receivable_shipments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @receivable_shipments }
    end
  end

  # GET receivables/1/receivable_shipments/1
  # GET receivables/1/receivable_shipments/1.json
  def show
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipment = @receivable.receivable_shipments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @receivable_shipment }
    end
  end

  # GET receivables/1/receivable_shipments/new
  # GET receivables/1/receivable_shipments/new.json
  def new
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipment = @receivable.receivable_shipments.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @receivable_shipment }
    end
  end

  # GET receivables/1/receivable_shipments/1/edit
  def edit
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipment = @receivable.receivable_shipments.find(params[:id])
  end

  # POST receivables/1/receivable_shipments
  # POST receivables/1/receivable_shipments.json
  def create
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipment = @receivable.receivable_shipments.build(params[:receivable_shipment])

    respond_to do |format|
      if @receivable_shipment.save
        format.html { redirect_to([@receivable_shipment.receivable, @receivable_shipment], :notice => 'Receivable shipment was successfully created.') }
        format.json { render :json => @receivable_shipment, :status => :created, :location => [@receivable_shipment.receivable, @receivable_shipment] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @receivable_shipment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT receivables/1/receivable_shipments/1
  # PUT receivables/1/receivable_shipments/1.json
  def update
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipment = @receivable.receivable_shipments.find(params[:id])

    respond_to do |format|
      if @receivable_shipment.update_attributes(params[:receivable_shipment])
        format.html { redirect_to([@receivable_shipment.receivable, @receivable_shipment], :notice => 'Receivable shipment was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @receivable_shipment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE receivables/1/receivable_shipments/1
  # DELETE receivables/1/receivable_shipments/1.json
  def destroy
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_shipment = @receivable.receivable_shipments.find(params[:id])
    @receivable_shipment.destroy

    respond_to do |format|
      format.html { redirect_to receivable_receivable_shipments_url(receivable) }
      format.json { head :ok }
    end
  end
end
