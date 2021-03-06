class CheckRegistersController < ApplicationController
  # GET /check_registers
  # GET /check_registers.json
  before_action :set_page_info
  before_action :user_permissions

  def user_permissions
    if  user_signed_in? && current_user.is_customer?
      authorize! :edit, CheckRegister
    end
  end

  def set_page_info
    unless user_signed_in? && current_user.is_customer?
      @menus[:general_ledger][:active] = "active"
    end
  end
  def index
    @check_registers = CheckRegister.all

    respond_to do |format|
      format.html # index.html.erb
      @check_registrs = Array.new
      format.json {
        @check_registers = @check_registers.select{|check_register|
           check_registr = Hash.new
           check_register.attributes.each do |key, value|
            check_registr[key] = value
           end
           check_registr[:organization] = check_register.payment.present? && check_register.payment.organization.present? ? CommonActions.linkable(organization_path(check_register.payment.organization), check_register.payment.organization.organization_name) : check_register.receipt.present? && check_register.receipt.organization.present? ? CommonActions.linkable(organization_path(check_register.receipt.organization), check_register.receipt.organization.organization_name) : "-"
           check_registr[:amount] =  check_register.amount.abs unless check_register.amount.nil?
           check_registr[:balance] =  check_register.balance.abs unless check_register.balance.nil?
           check_registr[:reconcile] =  check_register.rec ? "Y" : "N"
           @check_registrs.push(check_registr)
          }
          render json: {:aaData => @check_registrs}}
    end
  end

  # GET /check_registers/1
  # GET /check_registers/1.json
  def show
    @check_register = CheckRegister.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_register }
    end
  end

  # GET /check_registers/new
  # GET /check_registers/new.json
  def new
    @check_register = CheckRegister.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_register }
    end
  end

  # GET /check_registers/1/edit
  def edit
    @check_register = CheckRegister.find(params[:id])
  end

  # POST /check_registers
  # POST /check_registers.json
  def create
    @check_register = CheckRegister.new(check_register_params)

    respond_to do |format|
      if @check_register.save
        format.html { redirect_to @check_register, notice: 'Check register was successfully created.' }
        format.json { render json: @check_register, status: :created, location: @check_register }
      else
        format.html { render action: "new" }
        format.json { render json: @check_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_registers/1
  # PUT /check_registers/1.json
  def update
    @check_register = CheckRegister.find(params[:id])

    respond_to do |format|
      if @check_register.update_attributes(check_register_params)
        format.html { redirect_to @check_register, notice: 'Check register was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_registers/1
  # DELETE /check_registers/1.json
  def destroy
    @check_register = CheckRegister.find(params[:id])
    @check_register.destroy

    respond_to do |format|
      format.html { redirect_to check_registers_url }
      format.json { head :no_content }
    end
  end
  private

  def set_check_register
    @check_register = CheckRegister.find(params[:id])
  end

  def check_register_params
    params.require(:check_register).permit(:amount, :balance, :check_code, :deposit, :organization_id, :rec, :transaction_date, :payment_id, :receipt_id)
  end
end
