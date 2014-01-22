class ReceivableAccountsController < ApplicationController
  # GET receivables/1/receivable_accounts
  # GET receivables/1/receivable_accounts.json
  def index
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_accounts = @receivable.receivable_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @receivable_accounts }
    end
  end

  # GET receivables/1/receivable_accounts/1
  # GET receivables/1/receivable_accounts/1.json
  def show
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_account = @receivable.receivable_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @receivable_account }
    end
  end

  # GET receivables/1/receivable_accounts/new
  # GET receivables/1/receivable_accounts/new.json
  def new
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_account = @receivable.receivable_accounts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @receivable_account }
    end
  end

  # GET receivables/1/receivable_accounts/1/edit
  def edit
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_account = @receivable.receivable_accounts.find(params[:id])
  end

  # POST receivables/1/receivable_accounts
  # POST receivables/1/receivable_accounts.json
  def create
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_account = @receivable.receivable_accounts.build(params[:receivable_account])

    respond_to do |format|
      if @receivable_account.save
        format.html { redirect_to([@receivable_account.receivable, @receivable_account], :notice => 'Receivable account was successfully created.') }
        format.json { render :json => @receivable_account, :status => :created, :location => [@receivable_account.receivable, @receivable_account] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @receivable_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT receivables/1/receivable_accounts/1
  # PUT receivables/1/receivable_accounts/1.json
  def update
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_account = @receivable.receivable_accounts.find(params[:id])

    respond_to do |format|
      if @receivable_account.update_attributes(params[:receivable_account])
        format.html { redirect_to([@receivable_account.receivable, @receivable_account], :notice => 'Receivable account was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @receivable_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE receivables/1/receivable_accounts/1
  # DELETE receivables/1/receivable_accounts/1.json
  def destroy
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_account = @receivable.receivable_accounts.find(params[:id])
    @receivable_account.destroy

    respond_to do |format|
      format.html { redirect_to @receivable }
      format.json { head :ok }
    end
  end
end
