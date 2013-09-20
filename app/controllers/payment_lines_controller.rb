class PaymentLinesController < ApplicationController
  # GET payments/1/payment_lines
  # GET payments/1/payment_lines.json
  def index
    @payment = Payment.find(params[:payment_id])
    @payment_lines = @payment.payment_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @payment_lines }
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
