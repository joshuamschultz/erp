class PayablesController < ApplicationController
  before_filter :set_autocomplete_values, only: [:create, :update] 
  skip_before_filter :verify_authenticity_token, :only => :create

  before_filter :set_page_info  

  def set_page_info
      @menus[:accounts][:active] = "active"
  end

   def set_autocomplete_values
    if params[:payable].present?
      params[:payable][:po_header_id], params[:po_header_id] = params[:po_header_id], params[:payable][:po_header_id]
      params[:payable][:po_header_id] = params[:org_po_header_id] if params[:payable][:po_header_id] == ""
      params[:payable][:organization_id], params[:organization_id] = params[:organization_id], params[:payable][:organization_id]
      params[:payable][:organization_id] = params[:org_organization_id] if params[:payable][:organization_id] == ""
      # params[:payable][:gl_account_id], params[:gl_account_id] = params[:gl_account_id], params[:payable][:gl_account_id]
      # params[:payable][:gl_account_id] = params[:org_gl_account_id] if params[:payable][:gl_account_id] == ""
    end
  end

  # GET /payables
  # GET /payables.json
  def index
    if params[:item_id].present?
 
      @payables =Payable.open_payables(params[:item_id],params[:payable_status])


    else
    @payables = Payable.status_based_payables(params[:payable_status] || "open")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @payables = @payables.select{|payable|
              payable[:payable_identifier] = CommonActions.linkable(payable_path(payable), payable.payable_identifier)
              payable[:po_identifier] = payable.po_header.present? ? CommonActions.linkable(po_header_path(payable.po_header), payable.po_header.po_identifier) : "-"
              payable[:vendor_name] = payable.organization.present? ? CommonActions.linkable(organization_path(payable.organization), payable.organization.organization_name) : "-"
              if payable.payable_to_address
                payable[:payable_to_name] = CommonActions.linkable(contact_path(payable.payable_to_address), payable.payable_to_address.contact_description)
              elsif payable.organization
                payable[:payable_to_name] = CommonActions.linkable(organization_main_address_path(payable.organization), payable.organization.organization_name)
              else
                payable[:payable_to_name] = "-"
              end              
              payable[:links] = CommonActions.object_crud_paths(nil, edit_payable_path(payable), nil, 
                [ ({:name => "PAY", :path => new_payment_path(payable_id: payable.id)} if payable.payable_status == "open") ]
              )
          }
          render json: {:aaData => @payables}

      }
    end
  end

  # GET /payables/1
  # GET /payables/1.json
  def show
    @payable = Payable.find(params[:id])
    @po_header = @payable.po_header
    @attachable = @payable

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payable }
    end
  end

  # GET /payables/new
  # GET /payables/new.json
  def new
    @payable = Payable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payable }
    end
  end

  def manual_new
    @payable = Payable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payable }
    end
  end

  # GET /payables/1/edit
  def edit
    @payable = Payable.find(params[:id])
    @po_header = @payable.po_header
  end

  def manual_edit
    @payable = Payable.find(params[:id])
    @po_header = @payable.po_header
  end

  # POST /payables
  # POST /payables.json
  def create
    if params[:shipments].present?
        @payable = PoHeader.process_payable_po_lines(params)
    else
        @payable = Payable.new(params[:payable])
    end

    respond_to do |format|
      if @payable.save 
        # @payable.update_gl_account
        if @payable.payable_type == 'manual'
          format.html { redirect_to manual_edit_payable_path(@payable), notice: 'Payable was successfully created.' }
          format.json { render json: @payable, status: :created, location: @payable }
        else  
          format.html { redirect_to new_payable_payable_line_path(@payable), notice: 'Payable was successfully created.' }
          format.json { render json: @payable, status: :created, location: @payable }
        end  
      else
        p @payable.errors.to_yaml
        format.html { render action: "new" }
        format.json { render json: @payable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payables/1
  # PUT /payables/1.json
  def update
    @payable = Payable.find(params[:id])
    params[:payable][:payable_accounts_attributes] = @payable.process_removed_accounts(params[:payable][:payable_accounts_attributes])

    # Updating GlAccount 
    # accountsPayableAmt = 0     
    # @payable.payable_accounts.each do |payable_account|
    #    CommonActions.update_gl_accounts(payable_account.gl_account.gl_account_title, 'decrement',payable_account.payable_account_amount, @payable.id )                    
    #    accountsPayableAmt += payable_account.payable_account_amount
    # end
    # CommonActions.update_gl_accounts('ACCOUNTS PAYABLE', 'decrement',accountsPayableAmt, @payable.id )

    respond_to do |format|
      if @payable.update_attributes(params[:payable])
        # @payable.update_gl_account
        format.html { redirect_to @payable, notice: 'Payable was successfully updated.' }
        format.json { head :no_content }
      else
        p @payable.errors.to_json
        if @payable.payable_type == 'manual'
          format.html { render action: "manual_edit" }
          format.json { render json: @payable.errors, status: :unprocessable_entity }
        else
          format.html { render action: "edit" }
          format.json { render json: @payable.errors, status: :unprocessable_entity }
        end  
      end
    end
  end

  # DELETE /payables/1
  # DELETE /payables/1.json
  def destroy
    @payable = Payable.find(params[:id])
    # Updating GlAccount  
    # accountsPayableAmt = 0     
    # @payable.payable_accounts.each do |payable_account|
    #    CommonActions.update_gl_accounts(payable_account.gl_account.gl_account_title, 'decrement',payable_account.payable_account_amount,@payable.id   )             
    #    accountsPayableAmt += payable_account.payable_account_amount
    # end
    # CommonActions.update_gl_accounts('ACCOUNTS PAYABLE', 'decrement',accountsPayableAmt, @payable.id )
    @payable.destroy

    

    respond_to do |format|
      format.html { redirect_to payables_url }
      format.json { head :no_content }
    end
  end
end
