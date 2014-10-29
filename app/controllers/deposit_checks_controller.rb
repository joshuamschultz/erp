class DepositChecksController < ApplicationController
  # GET /deposit_checks
  # GET /deposit_checks.json
  def index
    @deposit_checks = DepositCheck.where(:active => 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @deposit_checks = @deposit_checks.select{|deposit_check|

              deposit_check[:receipt_type] = CommonActions.linkable(deposit_check_path(deposit_check), deposit_check.receipt_type)              
              deposit_check[:check_code] = CommonActions.linkable(receipt_path(deposit_check.receipt),deposit_check.check_identifier)
              receivables = deposit_check.get_receivables
              deposit_check[:receivables] = receivables

              deposit_check[:links] = CommonActions.object_crud_paths(nil, edit_deposit_check_path(deposit_check), nil)     

          }
         render json: {:aaData => @deposit_checks }  
      }
    end
  end

  # GET /deposit_checks/1
  # GET /deposit_checks/1.json
  def show
    @deposit_check = DepositCheck.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deposit_check }
    end
  end

  # GET /deposit_checks/new
  # GET /deposit_checks/new.json
  def new
    @deposit_check = DepositCheck.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deposit_check }
    end
  end

  # GET /deposit_checks/1/edit
  def edit
    @deposit_check = DepositCheck.find(params[:id])
  end

  # POST /deposit_checks
  # POST /deposit_checks.json
  def create
    @deposit_check = DepositCheck.new(params[:deposit_check])

    respond_to do |format|
      if @deposit_check.save
        format.html { redirect_to @deposit_check, notice: 'Deposit check was successfully created.' }
        format.json { render json: @deposit_check, status: :created, location: @deposit_check }
      else
        format.html { render action: "new" }
        format.json { render json: @deposit_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deposit_checks/1
  # PUT /deposit_checks/1.json
  def update
    @deposit_check = DepositCheck.find(params[:id])

    respond_to do |format|
      if @deposit_check.update_attributes(params[:deposit_check])
        format.html { redirect_to @deposit_check, notice: 'Deposit check was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deposit_check.errors, status: :unprocessable_entity }
      end
      if @deposit_check.status == "closed"
        reconcile = Reconcile.find_by_deposit_check_id(@deposit_check.id)
        reconcile.update_attribute(:tag, "not reconciled")
      end  
    end
  end

  # DELETE /deposit_checks/1
  # DELETE /deposit_checks/1.json
  def destroy
    @deposit_check = DepositCheck.find(params[:id])
    @deposit_check.destroy

    respond_to do |format|
      format.html { redirect_to deposit_checks_url }
      format.json { head :no_content }
    end
  end

   def report
    @deposit_checks = DepositCheck.where(:active => 1)
    render :layout => false
  end
end
