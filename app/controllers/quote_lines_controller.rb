class QuoteLinesController < ApplicationController
before_filter :set_autocomplete_values, only: [:create, :update]
  
  
  before_filter :set_page_info

  def set_page_info
      @menus[:quotes][:active] = "active"
  end
  
  def set_autocomplete_values    
    params[:quote_line][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:quote_line][:item_alt_name_id]
    params[:quote_line][:item_alt_name_id] = params[:org_alt_name_id] if params[:quote_line][:item_alt_name_id] == "" || params[:quote_line][:item_alt_name_id].nil?
  
    params[:quote_line][:organization_id], params[:organization_id] = params[:organization_id], params[:quote_line][:organization_id]
    params[:quote_line][:organization_id] = params[:org_organization_id] if params[:quote_line][:organization_id] == ""
  end

  def index
    @quote = Quote.find(params[:quote_id])
    @quote_lines = @quote.quote_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @quote_lines = @quote_lines.select{|quote_line|
              quote_line[:item_part_no] = CommonActions.linkable(item_path(quote_line.item), quote_line.item_alt_name.item_alt_identifier) if quote_line.item && quote_line.item_alt_name
              quote_line[:item_part_no] = quote_line.item_name_sub unless quote_line.item && quote_line.item_alt_name
              # quote_line[:customer_name] = quote_line.organization ? CommonActions.linkable(organization_path(quote_line.organization), quote_line.organization.organization_name) : ""
              #quote_line[:links] = CommonActions.object_crud_paths(nil, edit_quote_quote_line_path(@quote, quote_line), nil)
              quote_line[:links] = CommonActions.object_crud_paths(nil, edit_quote_quote_line_path(@quote, quote_line), quote_quote_line_path(@quote, quote_line))
          }
          render json: {:aaData => @quote_lines}
       }
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
    @attachable = @quote

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quote_line }
    end
  end

  # GET quotes/1/quote_lines/1/edit
  def edit
    @quote = Quote.find(params[:quote_id])
    @quote_line = @quote.quote_lines.find(params[:id])
    @attachable = @quote
  end

  # POST quotes/1/quote_lines
  # POST quotes/1/quote_lines.json
  def create    
    @quote = Quote.find(params[:quote_id])
    params[:quote_line][:item_name_sub] = params[:alt_name_id]
    @quote_line = @quote.quote_lines.build(params[:quote_line])
    @attachable = @quote

    respond_to do |format|
      if @quote_line.save
          @quote.quote_vendors.each do |quote_vendor|
              QuoteLineCost.create(quote_vendor_id: quote_vendor.id, quote_line_id: @quote_line.id)
          end
          
          format.html { redirect_to new_quote_quote_line_path(@quote), :notice => 'Quote line was successfully created.' }
          format.json { render :json => @quote_line, :status => :created, :location => [@quote_line.quote, @quote_line] }
          # if @quote.quote_vendors.count > 0
          #     @quote.quote_vendors.each do |quote_vendor|
          #         @dup_quote_line = @quote_line.clone
          #         @dup_quote_line.vendor_id = quote_vendor.organization_id
          #         @dup_quote_line.save
          #     end
          #     format.html { redirect_to new_quote_quote_line_path(@quote), :notice => 'Quote line was successfully created.' }
          #     format.json { render :json => @quote_line, :status => :created, :location => [@quote_line.quote, @quote_line] }
          # else
          #     format.html { redirect_to new_quote_quote_line_path(@quote), :notice => 'Please select vendors to add quote items.' }
          # end
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
        format.html { redirect_to new_quote_quote_line_path(@quote), :notice => 'Quote line was successfully updated.'}
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
      format.html { redirect_to new_quote_quote_line_path(@quote) }
      format.json { head :ok }
    end
  end
end
