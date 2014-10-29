class ReceiptsController < ApplicationController

  before_filter :set_autocomplete_values, only: [:create, :update]

  before_filter :set_page_info

  def set_page_info
    @menus[:accounts][:active] = "active"
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
      format.json {
        @receipts = @receipts.select{|receipt|
          receipt[:receipt_identifier] = CommonActions.linkable(receipt_path(receipt), receipt.receipt_identifier)
          receipt[:customer_name] = receipt.organization.present? ? CommonActions.linkable(organization_path(receipt.organization), receipt.organization.organization_name) : "-"
          receipt[:receipt_type_name] =  receipt.receipt_type.present? ? receipt.receipt_type.type_name : ""
          receipt[:links] = CommonActions.object_crud_paths(nil, edit_receipt_path(receipt), nil)
        }
        render json: {:aaData => @receipts}
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
    @receipt = Receipt.new(params[:receipt])

    respond_to do |format|
      if @receipt.save
        deposit_check = DepositCheck.find_by_receipt_id(@receipt.id)
        @receipt.update_attributes(:deposit_check_id => deposit_check.id) if deposit_check
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
      if @receipt.update_attributes(params[:receipt])
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
end