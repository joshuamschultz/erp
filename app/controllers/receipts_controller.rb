class ReceiptsController < ApplicationController

  before_action :set_autocomplete_values, only: [:create, :update]

  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && current_user.is_operations?
      authorize! :edit, Receipt
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
      authorize! :edit, Receipt
    end
  end

  def set_page_info
    unless  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
      @menus[:accounts][:active] = "active"
    end
  end


  def set_autocomplete_values
    params[:receipt][:organization_id], params[:organization_id] = params[:organization_id], params[:receipt][:organization_id]
    params[:receipt][:organization_id] = params[:org_organization_id] if params[:receipt][:organization_id] == ""
  end

  # GET /receipts
  # GET /receipts.json
  def index
    @receipts = Receipt.status_based_receipts(params[:receipt_status] || "open")

    respond_to do |format|
      format.html # index.html.erb
      @recipts = Array.new
      format.json {
        @receipts = @receipts.select{|receipt|
          recipt = Hash.new
          receipt.attributes.each do |key, value|
            recipt[key] = value
          end
          recipt[:receipt_identifier] = CommonActions.linkable(receipt_path(receipt), receipt.receipt_identifier)
          recipt[:customer_name] = receipt.organization.present? ? CommonActions.linkable(organization_path(receipt.organization), receipt.organization.organization_name) : "-"
          recipt[:receipt_type_name] =  receipt.receipt_type.present? ? receipt.receipt_type.type_name : ""
          recipt[:check_code] = ( receipt.receipt_type.present? && receipt.receipt_type.type_value == 'check' && receipt.deposit_check.present? ) ? receipt.deposit_check.check_identifier : "-"
          if can? :edit, Receipt
            recipt[:links] = CommonActions.object_crud_paths(nil, edit_receipt_path(receipt), nil)
          else
             recipt[:links] = ""
          end
          @recipts.push(recipt)
        }
        render json: {:aaData => @recipts}
      }
    end
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @receipt }
    end
  end

  # GET /receipts/new
  # GET /receipts/new.json
  def new
    @receipt = Receipt.new
    @receivable = Receivable.find(params[:receivable_id]) if params[:receivable_id].present?
    @receipt.organization = @receivable.organization if @receivable

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @receipt }
    end
  end

  # GET /receipts/1/edit
  def edit
    @receipt = Receipt.find(params[:id])
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        deposit_check = DepositCheck.find_by_receipt_id(@receipt.id)
        if deposit_check
          @receipt.update_attributes(:deposit_check_id => deposit_check.id)
        elsif @receipt.receipt_type.present? &&  @receipt.receipt_type.type_value == "check"
          depositCheck = DepositCheck.create(receipt_id: @receipt.id, status: "open", receipt_type: @receipt.receipt_type.type_value, check_identifier:  @receipt.receipt_check_code, active: 1)
          @receipt.update_attributes(:deposit_check_id => depositCheck.id)
        end
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render json: @receipt, status: :created, location: @receipt }
      else
        format.html { render action: "new" }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /receipts/1
  # PUT /receipts/1.json
  def update
    @receipt = Receipt.find(params[:id])
    params[:receipt][:receipt_lines_attributes] = @receipt.process_removed_lines(params[:receipt][:receipt_lines_attributes])

    respond_to do |format|
      if @receipt.update_attributes(receipt_params)
        deposit_check = DepositCheck.find_by_receipt_id(@receipt.id)
        @receipt.update_attributes(:deposit_check_id => deposit_check.id) if deposit_check
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy

    respond_to do |format|
      format.html { redirect_to receipts_url }
      format.json { head :no_content }
    end
  end

  private

    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    def receipt_params
      params.require(:receipt).permit(:receipt_active, :receipt_check_amount, :receipt_check_code, :receipt_check_no,
                                      :receipt_created_id, :receipt_description, :receipt_identifier, :receipt_notes, :receipt_status,
                                      :receipt_type_id, :receipt_updated_id, :organization_id,  :deposit_check_id, :receipt_discount, :receipt_type, receipt_lines_attributes: [:receipt_line_amount, :receipt_line_created_id, :receipt_line_updated_id,
                                           :receipt_id, :receivable_id])
    end
end
