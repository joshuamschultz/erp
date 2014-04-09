class CustomerQuotesController < ApplicationController
    before_filter :set_autocomplete_values, only: [:create, :update]
    before_filter :set_page_info

    def set_page_info
        @menus[:quotes][:active] = "active"
    end

    def set_autocomplete_values
      params[:customer_quote][:organization_id], params[:organization_id] = params[:organization_id], params[:customer_quote][:organization_id]
      params[:customer_quote][:organization_id] = params[:org_organization_id] if params[:customer_quote][:organization_id] == ""
    end

    def index
    # if params[:item_id]
    #     # item = Item.find(params[:item_id])
    #     # @quotes = item.quotes
    # elsif params[:organization_id]
    #     # organization = Organization.find(params[:organization_id])
    #     # @quotes = organization.quotes
    # else
        
    # end
    @customer_quotes = CustomerQuote.all
    respond_to do |format|
        format.html 
        format.json {  @customer_quotes = @customer_quotes.select{|customer_quote|
                 customer_quote[:customer_quote_identifier] = CommonActions.linkable(customer_quote_path(customer_quote), customer_quote.customer_quote_identifier)
                 customer_quote[:customer_name] = CommonActions.linkable(organization_path(customer_quote), customer_quote.organization.organization_name)
                 #customer_quote.quote_vendors.collect{|vendor| CommonActions.linkable(organization_path(vendor.organization), vendor.organization.organization_name) }.join(", ").html_safe
                 customer_quote[:links] = CommonActions.object_crud_paths(nil, edit_customer_quote_path(customer_quote), nil)
             }
             render json: {:aaData => @customer_quotes}
             }
        end
    end

    # GET /customer_quotes/1
    # GET /customer_quotes/1.json
    def show
      @customer_quote = CustomerQuote.find(params[:id])
      @attachable = @customer_quote
      @notes = @customer_quote.present? ? @customer_quote.comments.where(:comment_type => "note").order("created_at desc") : []  
   
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @customer_quote }
      end
    end

    # GET /customer_quotes/new
    # GET /customer_quotes/new.json
    def new
    @customer_quote = CustomerQuote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_quote }
    end
    end

    # GET /customer_quotes/1/edit
    def edit
    @customer_quote = CustomerQuote.find(params[:id])
    end

    # POST /customer_quotes
    # POST /customer_quotes.json
    def create
    @customer_quote = CustomerQuote.new(params[:customer_quote])

    respond_to do |format|
      if @customer_quote.save
        format.html { redirect_to new_customer_quote_customer_quote_line_path(@customer_quote), notice: 'Customer quote was successfully created.' }
        format.json { render json: @customer_quote, status: :created, location: @customer_quote }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_quote.errors, status: :unprocessable_entity }
      end
    end
    end

    # PUT /customer_quotes/1
    # PUT /customer_quotes/1.json
    def update

    @customer_quote = CustomerQuote.find(params[:id])
    p params[:customer_quote]

    respond_to do |format|
      if @customer_quote.update_attributes(params[:customer_quote])
        format.html { redirect_to @customer_quote, notice: 'Customer quote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_quote.errors, status: :unprocessable_entity }
      end
    end
    end

    # DELETE /customer_quotes/1
    # DELETE /customer_quotes/1.json
    def destroy
    @customer_quote = CustomerQuote.find(params[:id])
    @customer_quote.destroy

    respond_to do |format|
      format.html { redirect_to customer_quotes_url }
      format.json { head :no_content }
    end
    end
end