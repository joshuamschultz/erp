class CreditRegistersController < ApplicationController
  # GET /credit_registers
  # GET /credit_registers.json
  before_filter :set_page_info
  before_filter :user_permissions

  def user_permissions
   if  user_signed_in? && current_user.is_customer? 
        authorize! :edit, CreditRegister
    end 
  end

  def set_page_info
    unless user_signed_in? && current_user.is_customer? 
      @menus[:general_ledger][:active] = "active"
    end 
  end
  def index
    @credit_registers = CreditRegister.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @credit_registers = @credit_registers.select{|credit_register|
          @pidentifiers = Array.new() 
          @ridentifiers = Array.new()  
          register_id = ''
          if credit_register.payment_id.present?
            payable_ids = credit_register.payment.payment_lines.collect(&:payable_id)
            payable_ids.each do |p|
              payable = Payable.find (p)
              @pidentifiers.push(payable.payable_identifier)
            end 
          else
            receivable_ids = credit_register.receipt.receipt_lines.collect(&:receivable_id)
            receivable_ids.each do |r|
              receivable = Receivable.find (r)
              @ridentifiers.push(receivable.receivable_identifier)
            end 
          end
           credit_register[:payables] =  @pidentifiers.present? ? @pidentifiers : @ridentifiers
           credit_register[:organization] = credit_register.payment.present? ? credit_register.payment.present? && credit_register.payment.organization.present? ? CommonActions.linkable(organization_path(credit_register.payment.organization), credit_register.payment.organization.organization_name) :  "-" : credit_register.receipt.present? && credit_register.receipt.organization.present? ? CommonActions.linkable(organization_path(credit_register.receipt.organization), credit_register.receipt.organization.organization_name) :  "-"
           credit_register[:reconcile] =  credit_register.rec ? "Y" : "N"   
          }
        render json: {:aaData => @credit_registers }}
    end
  end

  # GET /credit_registers/1
  # GET /credit_registers/1.json
  def show
    @credit_register = CreditRegister.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @credit_register }
    end
  end

  # GET /credit_registers/new
  # GET /credit_registers/new.json
  def new
    @credit_register = CreditRegister.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @credit_register }
    end
  end

  # GET /credit_registers/1/edit
  def edit
    @credit_register = CreditRegister.find(params[:id])
  end

  # POST /credit_registers
  # POST /credit_registers.json
  def create
    @credit_register = CreditRegister.new(params[:credit_register])

    respond_to do |format|
      if @credit_register.save
        format.html { redirect_to @credit_register, notice: 'Credit register was successfully created.' }
        format.json { render json: @credit_register, status: :created, location: @credit_register }
      else
        format.html { render action: "new" }
        format.json { render json: @credit_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /credit_registers/1
  # PUT /credit_registers/1.json
  def update
    @credit_register = CreditRegister.find(params[:id])

    respond_to do |format|
      if @credit_register.update_attributes(params[:credit_register])
        format.html { redirect_to @credit_register, notice: 'Credit register was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @credit_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_registers/1
  # DELETE /credit_registers/1.json
  def destroy
    @credit_register = CreditRegister.find(params[:id])
    @credit_register.destroy

    respond_to do |format|
      format.html { redirect_to credit_registers_url }
      format.json { head :no_content }
    end
  end
end
