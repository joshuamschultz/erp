class DepositChecksController < ApplicationController
  # GET /deposit_checks
  # GET /deposit_checks.json
  before_action :user_permissions

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
      authorize! :edit, DepositCheck
    end
  end
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
              deposit_check[:receipt_customer] = CommonActions.linkable(organization_path(deposit_check.receipt.organization), deposit_check.receipt.organization.organization_name)
              deposit_check[:receipt_check_amount] = deposit_check.receipt.receipt_check_amount
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
    @deposit_check = DepositCheck.new(deposit_check_params)

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
      if @deposit_check.update_attributes(deposit_check_params)
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
  private

    def set_deposit_check
      @deposit_check = DepositCheck.find(params[:id])
    end

    def deposit_check_params
      params.require(:deposit_check).permit(:receipt_id, :status, :check_identifier, :receipt_type, :active)
    end

end
