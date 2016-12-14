class ReceiptLinesController < ApplicationController
  # GET receipts/1/receipt_lines
  # GET receipts/1/receipt_lines.json
  def index
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_lines = @receipt.receipt_lines

    respond_to do |format|
      format.html # index.html.erb
      @receipt_lins = Array.new
      format.json {
         @receipt_lines = @receipt_lines.select{|receipt_line|
              receipt_lin = Hash.new
              receipt_line.attributes.each do |key, value|
                receipt_lin[key] = value
              end
              receipt_lin[:receivable_identifier] = CommonActions.linkable(receivable_path(receipt_line.receivable), receipt_line.receivable.receivable_identifier)
              receipt_lin[:receivable_total] = receipt_line.receivable.receivable_total
              receipt_lin[:receivable_balance] = receipt_line.receivable.receivable_current_balance.round(2)
              # receipt_line[:receipt_line_discount] = receipt_line.receipt.receipt_discount !=nil ? (receipt_line[:receivable_total] * receipt_line.receipt.receipt_discount) / 100 : 0
              # receipt_line[:receipt_line_discount] = receipt_line[:receivable_total] - receipt_line.receipt_line_amount
              receipt_lin[:receipt_line_discount] = ((receipt_line.receivable.receivable_total * receipt_line.receipt.receipt_discount)/100).round(2)
              @receipt_lins.push(receipt_lin)
          }
          render json: {:aaData => @receipt_lins}
      }
    end
  end

  # GET receipts/1/receipt_lines/1
  # GET receipts/1/receipt_lines/1.json
  def show
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_line = @receipt.receipt_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @receipt_line }
    end
  end

  # GET receipts/1/receipt_lines/new
  # GET receipts/1/receipt_lines/new.json
  def new
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_line = @receipt.receipt_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @receipt_line }
    end
  end

  # GET receipts/1/receipt_lines/1/edit
  def edit
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_line = @receipt.receipt_lines.find(params[:id])
  end

  # POST receipts/1/receipt_lines
  # POST receipts/1/receipt_lines.json
  def create
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_line = @receipt.receipt_lines.build(params[:receipt_line])

    respond_to do |format|
      if @receipt_line.save
        format.html { redirect_to([@receipt_line.receipt, @receipt_line], :notice => 'Receipt line was successfully created.') }
        format.json { render :json => @receipt_line, :status => :created, :location => [@receipt_line.receipt, @receipt_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @receipt_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT receipts/1/receipt_lines/1
  # PUT receipts/1/receipt_lines/1.json
  def update
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_line = @receipt.receipt_lines.find(params[:id])

    respond_to do |format|
      if @receipt_line.update_attributes(params[:receipt_line])
        format.html { redirect_to([@receipt_line.receipt, @receipt_line], :notice => 'Receipt line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @receipt_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE receipts/1/receipt_lines/1
  # DELETE receipts/1/receipt_lines/1.json
  def destroy
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_line = @receipt.receipt_lines.find(params[:id])
    @receipt_line.destroy

    respond_to do |format|
      format.html { redirect_to receipt_receipt_lines_url(receipt) }
      format.json { head :ok }
    end
  end
end
