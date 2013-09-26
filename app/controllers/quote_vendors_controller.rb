class QuoteVendorsController < ApplicationController
  # GET quotes/1/quote_vendors
  # GET quotes/1/quote_vendors.json
  def index
    @quote = Quote.find(params[:quote_id])
    @quote_vendors = @quote.quote_vendors

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @quote_vendors }
    end
  end

  # GET quotes/1/quote_vendors/1
  # GET quotes/1/quote_vendors/1.json
  def show
    @quote = Quote.find(params[:quote_id])
    @quote_vendor = @quote.quote_vendors.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quote_vendor }
    end
  end

  # GET quotes/1/quote_vendors/new
  # GET quotes/1/quote_vendors/new.json
  def new
    @quote = Quote.find(params[:quote_id])
    @quote_vendor = @quote.quote_vendors.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quote_vendor }
    end
  end

  # GET quotes/1/quote_vendors/1/edit
  def edit
    @quote = Quote.find(params[:quote_id])
    @quote_vendor = @quote.quote_vendors.find(params[:id])
  end

  # POST quotes/1/quote_vendors
  # POST quotes/1/quote_vendors.json
  def create
    @quote = Quote.find(params[:quote_id])
    @quote_vendor = @quote.quote_vendors.build(params[:quote_vendor])

    respond_to do |format|
      if @quote_vendor.save
        format.html { redirect_to([@quote_vendor.quote, @quote_vendor], :notice => 'Quote vendor was successfully created.') }
        format.json { render :json => @quote_vendor, :status => :created, :location => [@quote_vendor.quote, @quote_vendor] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @quote_vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT quotes/1/quote_vendors/1
  # PUT quotes/1/quote_vendors/1.json
  def update
    @quote = Quote.find(params[:quote_id])
    @quote_vendor = @quote.quote_vendors.find(params[:id])

    respond_to do |format|
      if @quote_vendor.update_attributes(params[:quote_vendor])
        format.html { redirect_to([@quote_vendor.quote, @quote_vendor], :notice => 'Quote vendor was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @quote_vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE quotes/1/quote_vendors/1
  # DELETE quotes/1/quote_vendors/1.json
  def destroy
    @quote = Quote.find(params[:quote_id])
    @quote_vendor = @quote.quote_vendors.find(params[:id])
    @quote_vendor.destroy

    respond_to do |format|
      format.html { redirect_to quote_quote_vendors_url(quote) }
      format.json { head :ok }
    end
  end
end
