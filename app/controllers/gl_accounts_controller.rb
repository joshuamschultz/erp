class GlAccountsController < ApplicationController
  before_action :set_page_info
  autocomplete :gl_account, :gl_account_title, :full => true
  before_action :user_permissions

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_operations? || current_user.is_clerical?  || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, GlAccount
    end
  end
  def set_page_info
    unless user_signed_in? && (current_user.is_customer? || current_user.is_vendor? )
      @menus[:general_ledger][:active] = "active"
    end
  end
  # GET /gl_accounts
  # GET /gl_accounts.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      @gl_acounts = Array.new
      format.json {
          @gl_accounts = GlAccount.order(:gl_account_identifier).select{|gl_account|
           gl_acount = Hash.new
           gl_account.attributes.each do |key, value|
            gl_acount[key] = value
           end
           if can? :edit, GlAccount
            gl_acount[:links] = CommonActions.object_crud_paths(nil, edit_gl_account_path(gl_account),gl_account_path(gl_account))
           else
             gl_acount[:links] = ""
           end
            gl_acount[:gl_account_title] =   CommonActions.linkable(gl_entries_path({:gl_account => gl_account.id}), gl_account.gl_account_title)
            gl_acount[:gl_type_name] = CommonActions.linkable(gl_type_path(gl_account.gl_type), gl_account.gl_type.gl_name)
            gl_acount[:gl_type_side] = gl_account.gl_type.gl_side
            gl_acount[:gl_type_report] = gl_account.gl_type.gl_report
            gl_acount[:gl_account_amount] = gl_account.gl_account_amount
            @gl_acounts.push(gl_acount)
          }
          render json: {:aaData => @gl_acounts}
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
    @gl_account = GlAccount.new(gl_account_params)

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
      if @gl_account.update_attributes(gl_account_params)
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
   private

    def set_gl_account
      @gl_account = GlAccount.find(params[:id])
    end

    def gl_account_params
      params.require(:gl_account).permit(:gl_account_active, :gl_account_description, :gl_account_title, :gl_account_identifier, :gl_type_id, :gl_account_amount, :key_account)
    end


end
