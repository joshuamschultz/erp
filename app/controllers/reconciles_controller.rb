class ReconcilesController < ApplicationController
  before_action :find_reconciles, only: [:index]
  before_action :set_page_info

  before_action :user_permissions

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_operations? || current_user.is_clerical?  || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?)
        authorize! :edit, Reconcile
    end
  end

  # GET /reconciles
  # GET /reconciles.json
  def set_page_info
    unless user_signed_in? && (current_user.is_customer? || current_user.is_vendor? )
      @menus[:general_ledger][:active] = "active"
    end
  end

  def find_reconciles
      params[:reconcile_type] ||= nil
      if params[:reconcile_type].present?
        @reconciles = Reconcile.type_based_reconcile(params[:reconcile_type])
      else
         @reconciles = Reconcile.where(:tag => "not reconciled")
      end
  end


  def index

    gl_account = GlAccount.where('gl_account_identifier' => '11012' ).first
    @balance = gl_account.gl_account_amount
    Reconciled.create(:balance => 0) if Reconciled.all.empty?
    @reconciled = Reconciled.first.balance



    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @reconciles }
        @reconcils = Array.new
        format.json {

           @reconciles = @reconciles.select{|reconcile|
              i = reconcile.id
              reconcil = Hash.new
              reconcile.attributes.each do |key, value|
                reconcil[key] = value
              end
              reconcil[:ids] = CommonActions.linkable(reconcile_path(reconcile), reconcile.id)
              reconcil[:tag] = reconcile.tag
              reconcil[:reconcile_type] = reconcile.reconcile_type
              reconcil[:payment_name] = reconcile.payment.present? ? CommonActions.linkable(payment_path(reconcile.payment_id), reconcile.payment.payment_identifier) : ""
              reconcil[:receipt_name] = reconcile.receipt.present? ? CommonActions.linkable(receipt_path(reconcile.receipt_id), reconcile.receipt.receipt_identifier) : ""
              reconcil[:deposit_check_name] = reconcile.deposit_check.present? ? CommonActions.linkable(deposit_check_path(reconcile.deposit_check_id), reconcile.deposit_check.id) : ""
              reconcil[:check_entry_name] = reconcile.payment.present? && reconcile.payment.check_entry_id.present? ? CommonActions.linkable(check_entry_path(reconcile.payment.check_entry_id), reconcile.payment.check_entry.id) : ""
              reconcil[:amt] = reconcile.payment.present? ? reconcile.payment.payment_check_amount :  reconcile.receipt.present? ? reconcile.receipt.receipt_check_amount : 0
              if can? :edit, Reconcile
                reconcil[:links] = CommonActions.object_crud_paths(nil, edit_reconcile_path(reconcile), nil)
              else
                reconcil[:links] = ""
              end
              reconcil[:checkboxes] = CommonActions.check_boxes(reconcil[:amt],i ,'calcBalance(' + i.to_s + ',"'+reconcile.reconcile_type+'");' )
              @reconcils.push(reconcil)
          }
          render json: {:aaData => @reconcils}
      }
    end
  end

  # GET /reconciles/1
  # GET /reconciles/1.json
  def show
    @reconcile = Reconcile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reconcile }
    end
  end

  # GET /reconciles/new
  # GET /reconciles/new.json
  def new
    @reconcile = Reconcile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reconcile }
    end
  end

  # GET /reconciles/1/edit
  def edit
    @reconcile = Reconcile.find(params[:id])
  end

  # POST /reconciles
  # POST /reconciles.json
  def create
    @reconcile = Reconcile.new(reconcile_params)

    respond_to do |format|
      if @reconcile.save
        format.html { redirect_to @reconcile, notice: 'Reconcile was successfully created.' }
        format.json { render json: @reconcile, status: :created, location: @reconcile }
      else
        format.html { render action: "new" }
        format.json { render json: @reconcile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reconciles/1
  # PUT /reconciles/1.json
  def update
    @reconcile = Reconcile.find(params[:id])

    respond_to do |format|
      if @reconcile.update_attributes(reconcile_params)
        format.html { redirect_to @reconcile, notice: 'Reconcile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reconcile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reconciles/1
  # DELETE /reconciles/1.json
  def destroy
    @reconcile = Reconcile.find(params[:id])
    @reconcile.destroy

    respond_to do |format|
      format.html { redirect_to reconciles_url }
      format.json { head :no_content }
    end
  end
   private

    def set_reconcile
      @reconcile = Reconcile.find(params[:id])
    end

    def reconcile_params
      params.require(:notification).permit(:tag, :reconcile_type, :payment_id, :deposit_check_id, :printing_screen_id, :receipt_id)
    end
end
