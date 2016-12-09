class PaymentLinesController < ApplicationController
  # GET payments/1/payment_lines
  # GET payments/1/payment_lines.json
  def index
    @payment = Payment.find(params[:payment_id])
    @payment_lines = @payment.payment_lines

    respond_to do |format|
      format.html # index.html.erb
      @payment_lins = Array.new
      format.json {
          @payment_lines = @payment_lines.select{|payment_line|
              payment_lin = Hash.new
              payment_line.attributes.each do |key, value|
                payment_lin[key] = value
              end
              payment_lin[:payable_identifier] = CommonActions.linkable(payable_path(payment_line.payable), payment_line.payable.payable_identifier)
              payment_lin[:payable_invoice_date] = payment_line.payable.payable_invoice_date
              payment_lin[:payable_due_date] = payment_line.payable.payable_due_date
              payment_lin[:payable_total] = payment_line.payable.payable_total
              payment_lin[:payable_balance] = payment_line.payable.payable_current_balance
              @payment_lins.push(payment_lin)
          }
          render json: {:aaData => @payment_lins}
      }
    end
  end

  # GET payments/1/payment_lines/1
  # GET payments/1/payment_lines/1.json
  def show
    @payment = Payment.find(params[:payment_id])
    @payment_line = @payment.payment_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payment_line }
    end
  end

  # GET payments/1/payment_lines/new
  # GET payments/1/payment_lines/new.json
  def new
    @payment = Payment.find(params[:payment_id])
    @payment_line = @payment.payment_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payment_line }
    end
  end

  # GET payments/1/payment_lines/1/edit
  def edit
    @payment = Payment.find(params[:payment_id])
    @payment_line = @payment.payment_lines.find(params[:id])
  end

  # POST payments/1/payment_lines
  # POST payments/1/payment_lines.json
  def create
    @payment = Payment.find(params[:payment_id])
    @payment_line = @payment.payment_lines.build(params[:payment_line])

    respond_to do |format|
      if @payment_line.save
        format.html { redirect_to([@payment_line.payment, @payment_line], :notice => 'Payment line was successfully created.') }
        format.json { render :json => @payment_line, :status => :created, :location => [@payment_line.payment, @payment_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payment_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT payments/1/payment_lines/1
  # PUT payments/1/payment_lines/1.json
  def update
    @payment = Payment.find(params[:payment_id])
    @payment_line = @payment.payment_lines.find(params[:id])

    respond_to do |format|
      if @payment_line.update_attributes(params[:payment_line])
        format.html { redirect_to([@payment_line.payment, @payment_line], :notice => 'Payment line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payment_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE payments/1/payment_lines/1
  # DELETE payments/1/payment_lines/1.json
  def destroy
    @payment = Payment.find(params[:payment_id])
    @payment_line = @payment.payment_lines.find(params[:id])
    @payment_line.destroy

    respond_to do |format|
      format.html { redirect_to payment_payment_lines_url(payment) }
      format.json { head :ok }
    end
  end
end
