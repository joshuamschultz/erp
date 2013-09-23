class ReceiptLinesController < ApplicationController
  # GET receipts/1/receipt_lines
  # GET receipts/1/receipt_lines.json
  def index
    @receipt = Receipt.find(params[:receipt_id])
    @receipt_lines = @receipt.receipt_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @receipt_lines }
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
