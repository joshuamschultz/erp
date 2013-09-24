class PaymentsController < ApplicationController
  before_filter :set_autocomplete_values, only: [:create, :update]
  before_filter :set_page_info  

  def set_page_info
      @menus[:accounts][:active] = "active"
  end

  def set_autocomplete_values
    params[:payment][:organization_id], params[:organization_id] = params[:organization_id], params[:payment][:organization_id]
    params[:payment][:organization_id] = params[:org_organization_id] if params[:payment][:organization_id] == ""
  end

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @payments = @payments.select{|payment|
              payment[:payment_identifier] = CommonActions.linkable(payment_path(payment), payment.id)              
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        @payment.organization_id = ""
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
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        puts @payment.errors.to_yaml
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
