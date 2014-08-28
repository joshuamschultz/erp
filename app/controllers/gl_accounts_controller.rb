class GlAccountsController < ApplicationController
  before_filter :set_page_info  
  autocomplete :gl_account, :gl_account_title, :full => true

  def set_page_info
    @menus[:general_ledger][:active] = "active"
  end

  # GET /gl_accounts
  # GET /gl_accounts.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @gl_accounts = GlAccount.order(:gl_account_identifier).select{|gl_account| 
            gl_account[:links] = CommonActions.object_crud_paths(nil, edit_gl_account_path(gl_account),gl_account_path(gl_account))
            gl_account[:gl_account_title] =   CommonActions.linkable(gl_entries_path({:gl_account => gl_account.id}), gl_account.gl_account_title)         
            gl_account[:gl_type_name] = CommonActions.linkable(gl_type_path(gl_account.gl_type), gl_account.gl_type.gl_name)
            gl_account[:gl_type_side] = gl_account.gl_type.gl_side
            gl_account[:gl_type_report] = gl_account.gl_type.gl_report
            gl_account[:gl_account_amount] = gl_account.gl_account_amount
          }
          render json: {:aaData => @gl_accounts} 
      }
    end
  end

  # GET /gl_accounts/1
  # GET /gl_accounts/1.json
  def show
    @gl_account = GlAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gl_account }
    end
  end

  # GET /gl_accounts/new
  # GET /gl_accounts/new.json
  def new
    @gl_account = GlAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gl_account }
    end
  end

  # GET /gl_accounts/1/edit
  def edit
    @gl_account = GlAccount.find(params[:id])
  end

  # POST /gl_accounts
  # POST /gl_accounts.json
  def create
    @gl_account = GlAccount.new(params[:gl_account])

    respond_to do |format|
      if @gl_account.save
        format.html { redirect_to gl_accounts_path, notice: 'Gl account was successfully created.' }
        format.json { render json: @gl_account, status: :created, location: @gl_account }
      else
        format.html { render action: "new" }
        format.json { render json: @gl_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gl_accounts/1
  # PUT /gl_accounts/1.json
  def update
    @gl_account = GlAccount.find(params[:id])

    respond_to do |format|
      if @gl_account.update_attributes(params[:gl_account])
        format.html { redirect_to gl_accounts_path, notice: 'Gl account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gl_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gl_accounts/1
  # DELETE /gl_accounts/1.json
  def destroy
     @gl_account = GlAccount.find(params[:id])
     if @gl_account.key_account? == true
      respond_to do |format|
        format.html { redirect_to gl_accounts_url,  notice: 'This is a key account and cannot be deleted'}
        format.json { head :no_content }
      end
     else  
      @gl_account.destroy
      respond_to do |format|
        format.html { redirect_to gl_accounts_url }
        format.json { head :no_content }
      end
     end 
  end


  def gl_account_info
      @gl_account = GlAccount.find(params[:id])
      if @gl_account
        render :layout => false
      else
        render :text => "" and return
      end
  end



end
