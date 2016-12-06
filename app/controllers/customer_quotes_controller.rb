class CustomerQuotesController < ApplicationController
    before_action :set_autocomplete_values, only: [:create, :update]
    before_action :set_page_info

    before_action :view_permissions, except: [:index, :show]
    before_action :user_permissions


    def view_permissions
      if  user_signed_in? &&  current_user.is_customer?
          authorize! :edit, CustomerQuote
      end
    end

    def user_permissions
      if  user_signed_in? &&
        ( current_user.is_logistics? ||
          current_user.is_quality?   ||
          current_user.is_vendor? )
            authorize! :edit, CustomerQuote
      end
    end

    def set_page_info
      unless  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?  )
        @menus[:quotes][:active] = "active"
      end
    end

    def set_autocomplete_values
      params[:customer_quote][:organization_id], params[:organization_id] = params[:organization_id], params[:customer_quote][:organization_id]
      params[:customer_quote][:organization_id] = params[:org_organization_id] if params[:customer_quote][:organization_id] == ""
    end

    def index
      if params[:item_id]
        item = Item.find(params[:item_id])
        @customer_quotes = item.customer_quotes.order('created_at desc')
      elsif params[:organization_id]
        organization = Organization.find(params[:organization_id])
        @customer_quotes = organization.customer_quotes.order('created_at desc')
      else
          @customer_quotes = CustomerQuote.order('created_at desc')
      end

      respond_to do |format|
          i = 0
          @customer_qots = Array.new
          format.html
          if item
              format.json {  @customer_quotes = @customer_quotes.select{|customer_quote|
                    customer_qot = Hash.new
                    customer_quote.attributes.each do |key, value|
                        customer_qot[key] = value
                    end
                    customer_qot[:index] = i
                    customer_qot[:customer_quote_identifier] = CommonActions.linkable(customer_quote_path(customer_quote), customer_quote.customer_quote_identifier)
                    customer_qot[:customer_name] = CommonActions.linkable(organization_path(customer_quote.organization), customer_quote.organization.organization_name)
                    customer_qot[:created] = customer_quote.created_at.strftime("%d %b %Y")
                    customer_qot[:price] = customer_quote.customer_quote_lines.find_by_item_id(params[:item_id]).customer_quote_line_cost
                    customer_qot[:quantity] = customer_quote.customer_quote_lines.find_by_item_id(params[:item_id]).customer_quote_line_quantity
                    i = i+1
                    @customer_qots.push(customer_qot)
                 }
                 render json: {:aaData => @customer_qots}
                 }
          elsif organization
              format.json {  @customer_quotes = @customer_quotes.select{|customer_quote|
                    customer_qot = Hash.new
                    customer_quote.attributes.each do |key, value|
                      customer_qot[key] = value
                    end
                    customer_qot[:index] = i
                    customer_qot[:customer_quote_identifier] = CommonActions.linkable(customer_quote_path(customer_quote), customer_quote.customer_quote_identifier)
                    customer_qot[:created] = customer_quote.created_at.strftime("%d %b %Y")
                    customer_qot[:items] = CustomerQuote.get_qoute_items(customer_quote)
                    customer_qot[:price] = customer_quote.customer_quote_lines.collect{|customer_quote_line| customer_quote_line.customer_quote_line_cost }.join(", ").html_safe
                    customer_qot[:quantity] = customer_quote.customer_quote_lines.collect{|customer_quote_line| customer_quote_line.customer_quote_line_quantity }.join(", ").html_safe
                    # customer_quote[:status] =
                     i = i+1
                      @customer_qots.push(customer_qot)
                }
                 render json: {:aaData => @customer_qots}
                }
          else
            format.json {  @customer_quotes = @customer_quotes.select{|customer_quote|
                    customer_qot = Hash.new
                    customer_quote.attributes.each do |key, value|
                      customer_qot[key] = value
                    end
                     customer_qot[:index] = i
                     customer_qot[:customer_quote_identifier] = CommonActions.linkable(customer_quote_path(customer_quote), customer_quote.customer_quote_identifier)
                     customer_qot[:customer_name] = customer_quote.organization.present? ? CommonActions.linkable(organization_path(customer_quote.organization), customer_quote.organization.organization_name) : ''
                     if can? :edit, CustomerQuote
                      customer_qot[:links] = CommonActions.object_crud_paths(nil, edit_customer_quote_path(customer_quote), nil)
                      customer_qot[:links] = CommonActions.object_crud_paths(nil, customer_quote_customer_quote_lines_path(customer_quote), customer_quote_path(customer_quote))
                     else
                      customer_qot[:links] = nil
                      customer_qot[:links] = nil
                     end

                      customer_qot[:quote_status] =CommonActions.status_color(customer_quote.customer_quote_status)
                      i = i+1
                      @customer_qots.push(customer_qot)
                 }
                 render json: {:aaData => @customer_qots}
            }
          end
        end
    end

    # GET /customer_quotes/1
    # GET /customer_quotes/1.json
    def show
      @customer_quote = CustomerQuote.find(params[:id])
      @attachable = @customer_quote
      # @notes = @customer_quote.present? ? @customer_quote.comments.where(:comment_type => "note").order("created_at desc") : []
      @notes = @customer_quote.comments.where(:comment_type => "note").order("created_at desc") if @customer_quote

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @customer_quote }
      end
    end

    # GET /customer_quotes/new
    # GET /customer_quotes/new.json
    def new
    @customer_quote = CustomerQuote.new
    @attachable = @customer_quote
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
    @customer_quote = CustomerQuote.new(customer_quote_params)

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


    def populate
        @customer_quote = CustomerQuote.find(params[:id])

        if params[:type] == "note" && params[:comment].present?
            Comment.process_comments(current_user, @customer_quote, [params[:comment]], params[:type])
            note = @customer_quote.comments.where(:comment_type => "note").order("created_at desc").first if @customer_quote
            note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
            note["created_user"] = note.created_by.name
            note["status"] = "success"
        else
            note = Hash.new
            note["status"] = "fail"
        end

        render json: {:result => note}

    end
    private

      def set_customer_quote
        @customer_quote = CustomerQuote.find(params[:id])
      end

      def customer_quote_params
        params.require(:customer_quote).permit(:organization_id,:customer_quote_active, :customer_quote_created_id, :customer_quote_description, :customer_quote_identifier, :customer_quote_notes, :customer_quote_status, :customer_quote_updated_id)
      end
end
