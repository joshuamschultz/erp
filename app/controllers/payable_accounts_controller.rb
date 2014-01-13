class PayableAccountsController < ApplicationController
  # GET payables/1/payable_accounts
  # GET payables/1/payable_accounts.json
  def index
    @payable = Payable.find(params[:payable_id])
    @payable_accounts = @payable.payable_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @payable_accounts = @payable_accounts.includes(:gl_account).select{|payable_account| 
            payable_account[:links] = CommonActions.object_crud_paths(nil, edit_payable_payable_account_path(@payable, payable_account), payable_payable_account_path(@payable, payable_account))
            payable_account[:payable_account_name] = payable_account.gl_account ? CommonActions.linkable(gl_account_path(payable_account.gl_account), payable_account.gl_account.gl_account_title) : ""
          }
          render json: {:aaData => @payable_accounts} 
      }
    end
  end

  # GET payables/1/payable_accounts/1
  # GET payables/1/payable_accounts/1.json
  def show
    @payable = Payable.find(params[:payable_id])
    @payable_account = @payable.payable_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payable_account }
    end
  end

  # GET payables/1/payable_accounts/new
  # GET payables/1/payable_accounts/new.json
  def new
    @payable = Payable.find(params[:payable_id])
    @payable_account = @payable.payable_accounts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payable_account }
    end
  end

  # GET payables/1/payable_accounts/1/edit
  def edit
    @payable = Payable.find(params[:payable_id])
    @payable_account = @payable.payable_accounts.find(params[:id])
  end

  # POST payables/1/payable_accounts
  # POST payables/1/payable_accounts.json
  def create
    @payable = Payable.find(params[:payable_id])
    @payable_account = @payable.payable_accounts.build(params[:payable_account])

    respond_to do |format|
      if @payable_account.save
        format.html { redirect_to(@payable, :notice => 'Payable account was successfully created.') }
        format.json { render :json => @payable_account, :status => :created, :location => [@payable_account.payable, @payable_account] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payable_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT payables/1/payable_accounts/1
  # PUT payables/1/payable_accounts/1.json
  def update
    @payable = Payable.find(params[:payable_id])
    @payable_account = @payable.payable_accounts.find(params[:id])

    respond_to do |format|
      if @payable_account.update_attributes(params[:payable_account])
        format.html { redirect_to(@payable, :notice => 'Payable account was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payable_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE payables/1/payable_accounts/1
  # DELETE payables/1/payable_accounts/1.json
  def destroy
    @payable = Payable.find(params[:payable_id])
    @payable_account = @payable.payable_accounts.find(params[:id])
    @payable_account.destroy

    respond_to do |format|
      format.html { redirect_to @payable }
      format.json { head :ok }
    end
  end
end
