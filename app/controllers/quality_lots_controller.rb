class QualityLotsController < ApplicationController
  # GET po_headers/1/quality_lots
  # GET po_headers/1/quality_lots.json
  def index
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lots = @po_header.quality_lots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @quality_lots }
    end
  end

  # GET po_headers/1/quality_lots/1
  # GET po_headers/1/quality_lots/1.json
  def show
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quality_lot }
    end
  end

  # GET po_headers/1/quality_lots/new
  # GET po_headers/1/quality_lots/new.json
  def new
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quality_lot }
    end
  end

  # GET po_headers/1/quality_lots/1/edit
  def edit
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])
  end

  # POST po_headers/1/quality_lots
  # POST po_headers/1/quality_lots.json
  def create
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.build(params[:quality_lot])

    respond_to do |format|
      if @quality_lot.save
        format.html { redirect_to([@quality_lot.po_header, @quality_lot], :notice => 'Quality lot was successfully created.') }
        format.json { render :json => @quality_lot, :status => :created, :location => [@quality_lot.po_header, @quality_lot] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @quality_lot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT po_headers/1/quality_lots/1
  # PUT po_headers/1/quality_lots/1.json
  def update
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])

    respond_to do |format|
      if @quality_lot.update_attributes(params[:quality_lot])
        format.html { redirect_to([@quality_lot.po_header, @quality_lot], :notice => 'Quality lot was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @quality_lot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE po_headers/1/quality_lots/1
  # DELETE po_headers/1/quality_lots/1.json
  def destroy
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])
    @quality_lot.destroy

    respond_to do |format|
      format.html { redirect_to po_header_quality_lots_url(po_header) }
      format.json { head :ok }
    end
  end
end
