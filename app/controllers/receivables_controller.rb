class ReceivablesController < ApplicationController
  before_action :set_autocomplete_values, only: [:create, :update]
  skip_before_action :verify_authenticity_token, :only => :create

  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && current_user.is_operations?
      authorize! :edit, Receivable
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
      authorize! :edit, Receivable
    end
  end

  def set_page_info
    unless  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
      @menus[:accounts][:active] = "active"
    end
  end

  def set_autocomplete_values
    if params[:receivable].present?
      params[:receivable][:so_header_id], params[:so_header_id] = params[:so_header_id], params[:receivable][:so_header_id]
      params[:receivable][:so_header_id] = params[:org_so_header_id] if params[:receivable][:so_header_id] == ""
      params[:receivable][:organization_id], params[:organization_id] = params[:organization_id], params[:receivable][:organization_id]
      params[:receivable][:organization_id] = params[:org_organization_id] if params[:receivable][:organization_id] == ""

      # params[:receivable][:gl_account_id], params[:gl_account_id] = params[:gl_account_id], params[:receivable][:gl_account_id]
      # params[:receivable][:gl_account_id] = params[:org_gl_account_id] if params[:receivable][:gl_account_id] == ""
    end
  end

  # GET /receivables
  # GET /receivables.json
  def index
    if Receivable.find_by_receivable_disperse("unassigned").present?
      receivable = Receivable.find_by_receivable_disperse("unassigned")
      receivable.receivable_so_shipments.destroy_all
      receivable.delete
    end
    if params[:revision_id].present?
      @receivables =Receivable.open_revision_receivables(params[:revision_id],params[:receivable_status])
    elsif params[:item_id].present?
      @receivables =Receivable.open_receivables(params[:item_id],params[:receivable_status])
    else
      @receivables = Receivable.status_based_receivables(params[:receivable_status] || "open")
    end

    respond_to do |format|
      format.html # index.html.erb
      @receivabls = Array.new
      format.json {
        @receivables = @receivables.select{|receivble|
              receivabl = Hash.new
              receivable.attributes.each do |key, value|
                receivabl[key] = value
              end
              receivabl[:receivable_identifier] = CommonActions.linkable(receivable_path(receivble), receivble.receivable_identifier)
              receivabl[:so_identifier] = receivble.so_header.present? ? CommonActions.linkable(so_header_path(receivble.so_header), receivble.so_header.so_identifier) : "-"
              receivabl[:customer_name] = receivble.organization.present? ? CommonActions.linkable(organization_path(receivble.organization), receivble.organization.organization_name) : "-"
              receivabl["receivable_balance"] = receivble.receivable_current_balance
              if can? :edit, Receivable
                receivabl[:links] = CommonActions.object_crud_paths(nil, edit_receivable_path(receivble), nil,
                [ ({:name => "Receive", :path => new_receipt_path(receivable_id: receivble.id)} if receivble.receivable_status == "open") ]
              )
              else
                receivabl[:links] = ''
              end
              @receivabls.push(receivabl)
        }
        render json: {:aaData => @receivabls}
      }
    end
  end

  def report
    @receivables = Receivable.status_based_receivables(params[:receivable_status] || "open")
    @receivables.each do |receivable|
      @so_header = receivable.so_header rescue nil
    end
    @company_info = CompanyInfo.first
    render :layout => false
  end

  # GET /receivables/1
  # GET /receivables/1.json
  def show
    @receivable = Receivable.find(params[:id])
    @so_header = @receivable.so_header
    @receipt = @receivable.receipt_lines.last.receipt rescue nil
    @attachable = @receivable

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @receivable }
    end
  end

  # GET /receivables/new
  # GET /receivables/new.json
  def new
    @receivable = Receivable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @receivable }
    end
  end

  # GET /receivables/1/edit
  def edit
    @receivable = Receivable.find(params[:id])
    @so_header = @receivable.so_header
  end

  # POST /receivables
  # POST /receivables.json
  def create
    if params[:shipments].present?
        @receivable = SoHeader.process_receivable_so_lines(params)

    else
        @receivable = Receivable.new(params[:receivable])

    end

    respond_to do |format|
      if @receivable.save
        # @so_header = @receivable.so_header rescue nil
        # genarate_pdf
        # @receivable.update_gl_account
        format.html { redirect_to new_receivable_receivable_line_path(@receivable), notice: 'Invoice was successfully created.' }
        format.json { render json: @receivable, status: :created, location: @receivable }
      else
        format.html { render action: "new" }
        format.json { render json: @receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /receivables/1
  # PUT /receivables/1.json
  def update
    @receivable = Receivable.find(params[:id])

     # Updating GlAccount
    #  accountsReceivableAmt = 0
    #  @receivable.receivable_accounts.each do |receivable_account|
    #   CommonActions.update_gl_accounts(receivable_account.gl_account.gl_account_title, 'increment',receivable_account.receivable_account_amount, @receivable.id )
    #   accountsReceivableAmt+=receivable_account.receivable_account_amount
    #  end
    # CommonActions.update_gl_accounts('RECEIVBALE EMPLOYEES', 'decrement',accountsReceivableAmt, @receivable.id )

    # CommonActions.update_gl_accounts('FREIGHT ; UPS', 'increment',@receivable.receivable_freight )
    # CommonActions.update_gl_accounts('RECEIVBALE EMPLOYEES', 'decrement',@receivable.receivable_freight )


    respond_to do |format|
      if @receivable.update_attributes(params[:receivable])
        # @so_header = @receivable.so_header rescue nil
        # genarate_pdf
        if Receivable.find_by_receivable_disperse("unassigned").present?
          receivable = Receivable.find_by_receivable_disperse("unassigned")
          receivable.update_attributes(:receivable_disperse => "assigned")
        end
        format.html { redirect_to @receivable, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivables/1
  # DELETE /receivables/1.json
  def destroy
    @receivable = Receivable.find(params[:id])
    # accountsReceivableAmt = 0
    # @receivable.receivable_accounts.each do |receivable_account|
    #    CommonActions.update_gl_accounts(receivable_account.gl_account.gl_account_title, 'increment',receivable_account.receivable_account_amount, @receivable.id )
    #   accountsReceivableAmt+=receivable_account.payable_account_amount
    #  end
    # CommonActions.update_gl_accounts('RECEIVBALE EMPLOYEES', 'decrement',accountsReceivableAmt, @receivable.id )
    @receivable.destroy

    respond_to do |format|
      format.html { redirect_to receivables_url }
      format.json { head :no_content }
    end
  end

  def invoice_report
    @receivable = Receivable.find(params[:id])
    @so_header = @receivable.so_header rescue nil
    @company_info = CompanyInfo.first
    render :layout => false
  end
private

  def genarate_pdf
      html = render_to_string(:layout => false , :partial => 'receivables/invoice_report')
      kit = PDFKit.new(html, :page_size => 'A4')
      # Get an inline PDF
      pdf = kit.to_pdf
      p pdf
      # Save the PDF to a file
      path = Rails.root.to_s+"/public/invoice_report"
      if File.directory? path
        path = path+"/"+@so_header.so_identifier.to_s+".pdf"
        kit.to_file(path)
      else
        Dir.mkdir path
        path = path+"/"+@so_header.so_identifier.to_s+".pdf"
        kit.to_file(path)
      end
      p "===================================================="
        puts html
      p "==================================================="
  end
end
