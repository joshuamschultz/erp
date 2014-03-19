class QuotesController < ApplicationController
    before_filter :set_autocomplete_values, only: [:create, :update]

    def set_autocomplete_values
        params[:quote][:organization_id], params[:organization_id] = params[:organization_id], params[:quote][:organization_id]
        params[:quote][:organization_id] = params[:org_organization_id] if params[:quote][:organization_id] == ""
    end
    # GET /quotes
    # GET /quotes.json
    def index
        if params[:item_id]
            item = Item.find(params[:item_id])
            @quotes = item.quotes
        else
            @quotes = Quote.all
        end

        respond_to do |format|
            format.html # index.html.erb
            if item
                format.json {  @quotes = @quotes.select{|quote|
                                                 quote[:quote_group_id] = CommonActions.linkable(quote_path(quote), quote.quote_identifier)
                                                 quote[:vendor_name] = quote.quote_vendors.collect{|vendor| CommonActions.linkable(organization_path(vendor.organization), vendor.organization.organization_name) }.join(", ").html_safe
                                                 quote[:links] = CommonActions.object_crud_paths(nil, edit_quote_path(quote), nil)
                                                 quote[:created] = quote.created_at.strftime("%d %b %Y")
                                                 quote[:quantity] = quote.quote_lines.find_by_item_id(params[:item_id]).quote_line_quantity
                                                 quote[:price] = "1,2,25"
                                                 quote[:notes] = quote.quote_lines.find_by_item_id(params[:item_id]).quote_line_notes

                                             }
                                             render json: {:aaData => @quotes}
                                             }
            else
                format.json {  @quotes = @quotes.select{|quote|
                                                 quote[:quote_group_id] = CommonActions.linkable(quote_path(quote), quote.quote_identifier)
                                                 quote[:vendor_name] = quote.quote_vendors.collect{|vendor| CommonActions.linkable(organization_path(vendor.organization), vendor.organization.organization_name) }.join(", ").html_safe
                                                 quote[:links] = CommonActions.object_crud_paths(nil, edit_quote_path(quote), nil)
                                                 quote[:created] = quote.created_at.strftime("%d %b %Y")

                                             }
                                             render json: {:aaData => @quotes}
                                             }
            end
        end
    end

    # GET /quotes/1
    # GET /quotes/1.json
    def show
        @quote = Quote.find(params[:id])

        @attachable = @quote
        @notes = @quote.comments.where(:comment_type => "note").order("created_at desc") if @quote

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @quote }
        end
    end

    # GET /quotes/new
    # GET /quotes/new.json
    def new
        @quote = Quote.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @quote }
        end
    end

    # GET /quotes/1/edit
    def edit
        @quote = Quote.find(params[:id])
    end

    # POST /quotes
    # POST /quotes.json
    def create
        @quote = Quote.new(params[:quote])

        respond_to do |format|
            if @quote.save
                Quote.process_quote_associations(@quote, params)
                format.html { redirect_to new_quote_quote_line_path(@quote), notice: 'Quote was successfully created.' }
                format.json { render json: @quote, status: :created, location: @quote }
            else
                format.html { render action: "new" }
                format.json { render json: @quote.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /quotes/1
    # PUT /quotes/1.json
    def update
        @quote = Quote.find(params[:id])

        respond_to do |format|
            if params[:quote_po_type].present? && params[:quote].present?
                if @quote.process_quotes(params[:quote_po_type], params[:quote][:organization_id], params[:quote][:po_header_id], params[:item_quantity])
                    # if @quote.update_attributes(quote_po_type: params[:quote_po_type], organization_id: params[:quote][:organization_id], po_header_id: params[:quote][:po_header_id])

                    format.html { redirect_to quote_path(@quote), notice: 'Quote was successfully updated.' }
                else
                    format.html { redirect_to  quote_path(@quote)}
                end
            elsif params[:quote_po_type].nil? && @quote.update_attributes(params[:quote])
                Quote.process_quote_associations(@quote, params)
                format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @quote.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /quotes/1
    # DELETE /quotes/1.json
    def destroy
        @quote = Quote.find(params[:id])
        @quote.destroy

        respond_to do |format|
            format.html { redirect_to quotes_url }
            format.json { head :no_content }
        end
    end

    def populate
        @quote = Quote.find(params[:id])

        if params[:type] == "note"
            Comment.process_comments(current_user, @quote, [params[:comment]], params[:type])
        end

        redirect_to @quote
    end

    def history
        @quote_vendors = QuoteVendor.all
        respond_to do |format|
            format.html # index.html.erb
            format.json {  @quote_vendors = @quote_vendors.select{|quote_vendor|
                                             # quote_vendor[:part_no] = CommonActions.linkable(quote_path(quote), quote.quote_identifier)    link_to quote_line.item_alt_name.item_alt_identifier, item_path(quote_line.item)
                                             quote_vendor[:vendor_name] = CommonActions.linkable(organization_path(quote_vendor.organization), quote_vendor.organization.organization_name)
                                             # quote[:quantity] = quote_line_cost.object.quote_line.quote_line_quantity
                                             # quote[:links] = CommonActions.object_crud_paths(nil, edit_quote_path(quote), nil)
                                             # quote[:created] = quote.created_at.strftime("%d %b %Y")
                                         }
                                         render json: {:aaData => @quote_vendors}
                                         }
        end
    end

    def create_po

    end

end