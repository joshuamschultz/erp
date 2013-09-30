class QuoteLinesController < ApplicationController
  # GET quotes/1/quote_lines
  # GET quotes/1/quote_lines.json
  def index
    @quote = Quote.find(params[:quote_id])
    @quote_lines = @quote.quote_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @quote_lines }
    end
  end

  # GET quotes/1/quote_lines/1
  # GET quotes/1/quote_lines/1.json
  def show
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quote_line }
    end
  end

  # GET quotes/1/quote_lines/new
  # GET quotes/1/quote_lines/new.json
  def new
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quote_line }
    end
  end

  # GET quotes/1/quote_lines/1/edit
  def edit
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.find(params[:id])
  end

  # POST quotes/1/quote_lines
  # POST quotes/1/quote_lines.json
  def create
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.build(params[:quote_line])

    respond_to do |format|
      if @quote_line.save
        format.html { redirect_to([@quote_line.quote, @quote_line], :notice => 'Quote line was successfully created.') }
        format.json { render :json => @quote_line, :status => :created, :location => [@quote_line.quote, @quote_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @quote_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT quotes/1/quote_lines/1
  # PUT quotes/1/quote_lines/1.json
  def update
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.find(params[:id])

    respond_to do |format|
      if @quote_line.update_attributes(params[:quote_line])
        format.html { redirect_to([@quote_line.quote, @quote_line], :notice => 'Quote line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @quote_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE quotes/1/quote_lines/1
  # DELETE quotes/1/quote_lines/1.json
  def destroy
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.find(params[:id])
    @quote_line.destroy

    respond_to do |format|
      format.html { redirect_to quote_quote_lines_url(quote) }
      format.json { head :ok }
    end
  end
end