class CheckRegistersController < ApplicationController
  # GET /check_registers
  # GET /check_registers.json
  def index
    @check_registers = CheckRegister.all

    respond_to do |format|
      format.html # index.html.erb
      format.json {  
        @check_registers = @check_registers.select{|check_register| 
          
           check_register[:organization] = check_register.payment.present? && check_register.payment.organization.present? ? CommonActions.linkable(organization_path(check_register.payment.organization), check_register.payment.organization.organization_name) : check_register.receipt.present? && check_register.receipt.organization.present? ? CommonActions.linkable(organization_path(check_register.receipt.organization), check_register.receipt.organization.organization_name) : "-"
           check_register[:reconcile] =  check_register.rec ? "Y" : "N"   
          }
          render json: {:aaData => @check_registers}}
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
    @check_register = CheckRegister.new(params[:check_register])

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
      if @check_register.update_attributes(params[:check_register])
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
end
