class PaymentsController < ApplicationController
  before_filter :set_autocomplete_values, only: [:create, :update]
  before_filter :set_page_info

  def set_page_info
    @menus[:accounts][:active] = "active"
  end

  def set_autocomplete_values
    params[:payment][:organization_id], params[:organization_id] = params[:organization_id], params[:payment][:organization_id]
    params[:payment][:organization_id] = params[:org_organization_id] if params[:payment][:organization_id] == ""

    # if params[:payment][:check_entry_attributes][:check_code].nil? || params[:payment][:check_entry_attributes][:check_code].blank?
    #     params[:payment][:check_entry_attributes] = {}
    #     params[:payment][:check_entry_id] = nil
    # else
    #     check_entry = CheckEntry.find_by_check_code(params[:payment][:check_entry_attributes][:check_code])
    #     if check_entry.nil?
    #         params[:payment][:check_entry_attributes] = {check_code: params[:payment][:check_entry_attributes][:check_code]}
    #     else
    #         params[:payment][:check_entry_id] = check_entry.id
    #         params[:payment][:check_entry_attributes] = {check_code: check_entry.check_code, id: check_entry.id}
    #     end
    # end
  end

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.status_based_payments(params[:payment_status] || "open")

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @payments = @payments.select{|payment|
          payment[:payment_identifier] = CommonActions.linkable(payment_path(payment), payment.payment_identifier)
          payment[:vendor_name] = payment.organization.present? ? CommonActions.linkable(organization_path(payment.organization), payment.organization.organization_name) : "-"
          payment[:payment_type_name] =  payment.payment_type.present? ? payment.payment_type.type_name : ""
          payment[:links] = CommonActions.object_crud_paths(nil, edit_payment_path(payment), nil)
        }
        render json: {:aaData => @payments}
      }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new
    @payable = Payable.find(params[:payable_id]) if params[:payable_id].present?
    @payment.organization = @payable.organization if @payable

    @payment.build_check_entry

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
    @payment.build_check_entry if @payment.check_entry.nil?
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        check_entry = CheckEntry.find_by_check_code(@payment.payment_check_code)
        @payment.update_attributes(:check_entry_id => check_entry.id) if check_entry

        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        p @payment.errors.to_yaml
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])
    params[:payment][:payment_lines_attributes] = @payment.process_removed_lines(params[:payment][:payment_lines_attributes])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        check_entry = CheckEntry.find_by_check_code(@payment.payment_check_code)
        @payment.update_attributes(:check_entry_id => check_entry.id) if check_entry
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end
end