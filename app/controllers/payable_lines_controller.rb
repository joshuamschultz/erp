class PayableLinesController < ApplicationController
  # GET payables/1/payable_lines
  # GET payables/1/payable_lines.json
  def index
    @payable = Payable.find(params[:payable_id])
    @po_header = @payable.po_header
    @payable_lines = @payable.payable_lines

    respond_to do |format|
      format.html { 
          # redirect_to new_payable_payable_line_path(@payable) 
      }
      format.json { 
          @payable_lines = @payable_lines.select{|payable_line|              
              payable_line[:links] = CommonActions.object_crud_paths(nil, edit_payable_payable_line_path(@payable, payable_line), nil)
          }
          render json: {:aaData => @payable_lines}
      }
    end
  end

  # GET payables/1/payable_lines/1
  # GET payables/1/payable_lines/1.json
  def show
    @payable = Payable.find(params[:payable_id])    
    @payable_line = @payable.payable_lines.find(params[:id])    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payable_line }
    end
  end

  # GET payables/1/payable_lines/new
  # GET payables/1/payable_lines/new.json
  def new
    @payable = Payable.find(params[:payable_id])
    @po_header = @payable.po_header
    @payable_line = @payable.payable_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payable_line }
    end
  end

  # GET payables/1/payable_lines/1/edit
  def edit
    @payable = Payable.find(params[:payable_id])
    @po_header = @payable.po_header
    @payable_line = @payable.payable_lines.find(params[:id])
  end

  # POST payables/1/payable_lines
  # POST payables/1/payable_lines.json
  def create
    @payable = Payable.find(params[:payable_id])
    @payable_line = @payable.payable_lines.build(params[:payable_line])

    respond_to do |format|
      if @payable_line.save
        format.html { redirect_to(new_payable_payable_line_path(@payable), :notice => 'Line item was successfully created.') }
        format.json { render :json => @payable_line, :status => :created, :location => [@payable_line.payable, @payable_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payable_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT payables/1/payable_lines/1
  # PUT payables/1/payable_lines/1.json
  def update
    @payable = Payable.find(params[:payable_id])
    @payable_line = @payable.payable_lines.find(params[:id])
    
      #Updating GlAccount 
    if @payable_line
        CommonActions.update_gl_accounts('INVENTORY', 'decrement',@payable_line.payable_line_cost )
        CommonActions.update_gl_accounts('ACCOUNTS PAYABLE', 'decrement',@payable_line.payable_line_cost )
    end  

    respond_to do |format|
      if @payable_line.update_attributes(params[:payable_line])
        format.html { redirect_to(new_payable_payable_line_path(@payable), :notice => 'Line item was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payable_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE payables/1/payable_lines/1
  # DELETE payables/1/payable_lines/1.json
  def destroy
    @payable = Payable.find(params[:payable_id])
    @payable_line = @payable.payable_lines.find(params[:id])
    @payable_line.destroy

    respond_to do |format|
      format.html { redirect_to(new_payable_payable_line_path(@payable), :notice => 'Line item was successfully deleted.') }
      format.json { head :ok }
    end
  end
end
