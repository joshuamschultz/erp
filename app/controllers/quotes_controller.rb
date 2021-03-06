class QuotesController < ApplicationController
    before_action :set_autocomplete_values, only: [:create, :update]
    before_action :set_page_info
    before_action :user_permissions

    def user_permissions
        if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?  || current_user.is_customer? )
         authorize! :edit, User
        end
    end

    def set_page_info
        unless  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?  )
             @menus[:quotes][:active] = "active"
        end
    end

    def set_autocomplete_values
        # params[:quote][:customer_id], params[:customer_id] = params[:customer_id], params[:quote][:customer_id]
        # params[:quote][:customer_id] = params[:org_customer_id] if params[:quote][:customer_id] == ""


        params[:quote][:customer_id], params[:customer_id] = params[:customer_id], params[:quote][:customer_id]
        params[:quote][:customer_id] = params[:org_customer_id] if params[:quote][:customer_id] == ""
    end
    # GET /quotes
    # GET /quotes.json
    def index
        if params[:item_id]
            item = Item.find(params[:item_id])
            @quotes = item.quotes.order('created_at desc')
        elsif params[:organization_id]
            organization = Organization.find(params[:organization_id])
            @quotes = organization.quote_vendors.joins(:quote).order('quotes.created_at desc').collect{ |quote_vendor| quote_vendor.quote}
        else
             if  user_signed_in? && current_user.is_vendor?
                 @quotes = Quote.where(:user_id => User.current_user.id).order('created_at desc')
             else
                @quotes = Quote.order('created_at desc')
             end
        end

        respond_to do |format|
            if  user_signed_in? && current_user.is_vendor?
                @quotes = Quote.where(:user_id => User.current_user.id).order('created_at desc')

                 ids = current_user.organizations.collect(&:id)
                 @quotes = Quote.includes(:quote_vendors).where(quote_vendors: {organization_id: ids})
            end
            format.html # index.html.erb

            if item
                 i = 0
                 @qots = Array.new
                format.json {  @quotes = @quotes.select{|quote|
                                      qot = Hash.new
                                      quote.attributes.each do |key, value|
                                        qot[key] = value
                                      end
                                     qot[:index] = i
                                     qot[:quote_group_id] = CommonActions.linkable(quote_path(quote), quote.quote_identifier)
                                     qot[:vendor_name] = quote.quote_vendors.collect{|vendor| CommonActions.linkable(organization_path(vendor.organization), vendor.organization.organization_name) }.join(", ").html_safe
                                    if  user_signed_in? && !current_user.is_vendor?
                                        qot[:links] = CommonActions.object_crud_paths(nil, edit_quote_path(quote), nil) if can? :update, @quotes
                                    else
                                        qot[:links] = CommonActions.object_crud_paths(nil, nil, nil) if can? :update, @quotes
                                    end
                                     qot[:created] = quote.created_at.strftime("%d %b %Y")
                                     qot[:quantity] = quote.quote_lines.find_by_item_id(params[:item_id]).quote_line_quantity
                                     qot[:price] = Quote.get_quote_item_prices(quote, params[:item_id])
                                     qot[:notes] = quote.quote_lines.find_by_item_id(params[:item_id]).quote_line_notes
                                     i += 1
                                     @qots.push(qot)
                                 }
                                 render json: {:aaData => @qots}
                                 }
            elsif organization
                 i = 0
                 @qots = Array.new
                format.json {  @quotes = @quotes.select{|quote|
                                    qot = Hash.new
                                    quote.attributes.each do |key, value|
                                        qot[key] = value
                                    end
                                     qot[:index] = i
                                     qot[:quote_group_id] = CommonActions.linkable(quote_path(quote), quote.quote_identifier)
                                     qot[:vendor_name] = quote.quote_vendors.collect{|vendor| CommonActions.linkable(organization_path(vendor.organization), vendor.organization.organization_name) }.join(", ").html_safe
                                     qot[:links] = CommonActions.object_crud_paths(nil, edit_quote_path(quote), nil)
                                     qot[:created] = quote.created_at.strftime("%d %b %Y")
                                     qot[:quantity] = quote.quote_lines.collect{|quote_line| quote_line.quote_line_quantity }.join(", ").html_safe
                                     qot[:price] = Quote.get_quote_item_prices_org(quote, organization)
                                     qot[:part_no] = Quote.item_list(quote)
                                     qot[:notes] = quote.quote_lines.collect{|quote_line| quote_line.quote_line_notes }.join(", ").html_safe
                                     i += 1
                                     @qots.push(qot)
                                 }
                                 render json: {:aaData => @qots}
                                 }
            else
                 i = 0
                 @qots = Array.new
                format.json {  @quotes = @quotes.select{|quote|
                                qot = Hash.new
                                quote.attributes.each do |key, value|
                                    qot[key] = value
                                end
                                 qot[:index] = i
                                 qot[:quote_group_id] = CommonActions.linkable(quote_path(quote), quote.quote_identifier)
                                 qot[:vendor_name] = quote.quote_vendors.collect{|vendor| CommonActions.linkable(organization_path(vendor.organization), vendor.organization.organization_name) }.join(", ").html_safe
                                if  user_signed_in? && !current_user.is_vendor?
                                    qot[:links] = CommonActions.object_crud_paths(nil, edit_quote_path(quote), nil)
                                    qot[:links] = CommonActions.object_crud_paths(nil, new_quote_quote_line_path(quote), quote_path(quote))
                                else
                                    qot[:links] = CommonActions.object_crud_paths(nil, nil, nil)
                                    qot[:links] = CommonActions.object_crud_paths(nil, nil,quote_path(quote))
                                end
                                 qot[:created] = quote.created_at.strftime("%d %b %Y")
                                 qot[:quote_status] = CommonActions.status_color(quote.quote_status)
                                 i += 1
                                 @qots.push(qot)
                             }
                             render json: {:aaData => @qots}
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
        @quote = Quote.new(quote_params)
        if params[:vendor_type] == 'Vendor'
            @quote.group_id = ''
        end
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
            elsif params[:quote_po_type].nil? && @quote.update_attributes(quote_params)
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

        if params[:type] == "note" && params[:comment].present?
            Comment.process_comments(current_user, @quote, [params[:comment]], params[:type])
            note = @quote.comments.where(:comment_type => "note").order("created_at desc").first if @quote
            note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
            note["created_user"] = note.created_by.name
            note["status"] = "success"
        else
            note = Hash.new
            note["status"] = "fail"
        end

        render json: {:result => note}
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
    private

        def set_quote
            @quote = Quote.find(params[:id])
        end

        def quote_params
          params.require(:quote).permit(:quote_active, :quote_created_id, :quote_description, :quote_identifier,
                                        :quote_notes, :quote_status, :quote_total, :quote_updated_id, :organization_id, :po_header_id,
                                        :quote_po_type, :item_quantity, :customer_id, :group_id, :attachment_public)
        end

end
