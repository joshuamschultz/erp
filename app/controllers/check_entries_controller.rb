class CheckEntriesController < ApplicationController
  before_action :user_permissions


  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
      authorize! :edit, CheckEntry
    end
  end
  # GET /check_entries
  # GET /check_entries.json
  def index
    @check_entries = CheckEntry.where(:check_active => true)
    @check_entris = Array.new
    respond_to do |format|
      format.html # index.html.erb
      format.json {
          @check_entries = @check_entries.select{|check_entry|
            check_entri = Hash.new
            check_entry.attributes.each do |key, value|
              check_entri[key] = value
            end
            # check_data = check_entry.check_belongs_to
            # check_entry[:check_identifier] = check_entry.check_belongs_to.nil? ? check_entry.check_code : CommonActions.linkable(check_data[:object].redirect_path, check_entry.check_code)
            check_entri[:links] = CommonActions.object_crud_paths(nil, edit_check_entry_path(check_entry), check_entry_path(check_entry))
            payables = get_payables(check_entry)
            check_entri[:payables] = payables["payableIds"]
            @check_entris.push(check_entri)
          }
          render json: {:aaData => @check_entris}
      }
    end
  end

  # GET /check_entries/1
  # GET /check_entries/1.json
  def show
    @check_entry = CheckEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_entry }
    end
  end

  # GET /check_entries/new
  # GET /check_entries/new.json
  def new
    @check_entry = CheckEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_entry }
    end
  end

  # GET /check_entries/1/edit
  def edit
    @check_entry = CheckEntry.find(params[:id])
  end

  # POST /check_entries
  # POST /check_entries.json
  def create
    @check_entry = CheckEntry.new(check_entry_params)

    respond_to do |format|
      if @check_entry.save
        format.html { redirect_to @check_entry, notice: 'Check entry was successfully created.' }
        format.json { render json: @check_entry, status: :created, location: @check_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @check_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_entries/1
  # PUT /check_entries/1.json
  def update
    @check_entry = CheckEntry.find(params[:id])

    respond_to do |format|
      if @check_entry.update_attributes(check_entry_params)
        format.html { redirect_to @check_entry, notice: 'Check entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_entries/1
  # DELETE /check_entries/1.json
  def destroy
    @check_entry = CheckEntry.find(params[:id])
    @check_entry.destroy

    respond_to do |format|
      format.html { redirect_to check_entries_url }
      format.json { head :no_content }
    end
  end

  def report
    @check_entries = CheckEntry.where(:check_active => 1)
    render :layout => false
  end

  def generate_check_entry
    if params[:serial_no].present? && params[:serial_end].present?
        for serial in params[:serial_no].to_i..params[:serial_end].to_i
            @check_entry = CheckEntry.new(check_active: true, check_code: serial, check_identifier: serial)
            @check_entry.save
        end
    end
    redirect_to check_entries_url
  end
  private

    def get_payables(entry)
      identifiers = Array.new
      result ={}
      if entry.payment
        payable_ids = entry.payment.payment_lines.collect(&:payable_id)
        payable_ids.each do |p|
          payable = Payable.find (p)
          if payable.present?
            identifiers.push(CommonActions.linkable(payable_path(payable), payable.payable_identifier))
          end
        end
        result["payableIds"] = identifiers
        result["amount"] = entry.payment.payment_check_amount
      end
      result
    end


    def set_check_entry
      @check_entry = CheckEntry.find(params[:id])
    end

    def check_entry_params
      params.require(:check_entry).permit(:check_active, :check_code, :check_identifier, :status)
    end
end
