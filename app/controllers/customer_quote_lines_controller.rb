class CustomerQuoteLinesController < ApplicationController
    before_filter :set_page_info
    before_filter :set_autocomplete_values, only: [:create, :update]

    def set_page_info
      @menus[:quotes][:active] = "active"
    end

    def set_autocomplete_values
        params[:customer_quote_line][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:customer_quote_line][:item_alt_name_id]
        params[:customer_quote_line][:item_alt_name_id] = params[:org_alt_name_id] if params[:customer_quote_line][:item_alt_name_id] == "" || params[:customer_quote_line][:item_alt_name_id].nil?
    end

    def index
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_lines = @customer_quote.customer_quote_lines
        
        respond_to do |format|
            format.html # index.html.erb
            format.json { 
                @customer_quote_lines = @customer_quote_lines.select{|customer_quote_line|
                    customer_quote_line[:item_part_no] = CommonActions.linkable(item_path(customer_quote_line.item), customer_quote_line.item_alt_name.item_alt_identifier) if customer_quote_line.item && customer_quote_line.item_alt_name
                    customer_quote_line[:links] = CommonActions.object_crud_paths(nil, edit_customer_quote_customer_quote_line_path(@customer_quote, customer_quote_line), nil)
                }
                render json: {:aaData => @customer_quote_lines}
            }
        end
    end

    # GET customer_quotes/1/customer_quote_lines/1
    # GET customer_quotes/1/customer_quote_lines/1.json
    def show
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_line = @customer_quote.customer_quote_lines.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.json { render :json => @customer_quote_line }
        end
    end

    # GET customer_quotes/1/customer_quote_lines/new
    # GET customer_quotes/1/customer_quote_lines/new.json
    def new
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_line = @customer_quote.customer_quote_lines.build

        respond_to do |format|
          format.html # new.html.erb
          format.json { render :json => @customer_quote_line }
        end
    end

    # GET customer_quotes/1/customer_quote_lines/1/edit
    def edit
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_line = @customer_quote.customer_quote_lines.find(params[:id])
    end

    # POST customer_quotes/1/customer_quote_lines
    # POST customer_quotes/1/customer_quote_lines.json
    def create
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_line = @customer_quote.customer_quote_lines.build(params[:customer_quote_line])

        respond_to do |format|
          if @customer_quote_line.save
            format.html { redirect_to new_customer_quote_customer_quote_line_path(@customer_quote), :notice => 'Customer quote line was successfully created.' }
            format.json { render :json => @customer_quote_line, :status => :created, :location => [@customer_quote_line.customer_quote, @customer_quote_line] }
          else
            format.html { render :action => "new" }
            format.json { render :json => @customer_quote_line.errors, :status => :unprocessable_entity }
          end
        end
    end

    # PUT customer_quotes/1/customer_quote_lines/1
    # PUT customer_quotes/1/customer_quote_lines/1.json
    def update
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_line = @customer_quote.customer_quote_lines.find(params[:id])

        respond_to do |format|
          if @customer_quote_line.update_attributes(params[:customer_quote_line])
            format.html { redirect_to customer_quote_path(@customer_quote), :notice => 'Customer quote line was successfully updated.' }
            format.json { head :ok }
          else
            format.html { render :action => "edit" }
            format.json { render :json => @customer_quote_line.errors, :status => :unprocessable_entity }
          end
        end
    end

    # DELETE customer_quotes/1/customer_quote_lines/1
    # DELETE customer_quotes/1/customer_quote_lines/1.json
    def destroy
        @customer_quote = CustomerQuote.find(params[:customer_quote_id])
        @customer_quote_line = @customer_quote.customer_quote_lines.find(params[:id])
        @customer_quote_line.destroy

        respond_to do |format|
          format.html { redirect_to customer_quote_path(@customer_quote), :notice => 'Customer quote line was deleted updated.' }
          format.json { head :ok }
        end
    end
end
