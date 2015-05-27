class CheckCodesController < ApplicationController
  before_filter :set_page_info
  def set_page_info
    @menus[:system][:active] = "active"
  end

  # GET /check_codes
  # GET /check_codes.json
  def index
    @check_codes = CheckCode.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @check_codes }
    end
  end

  # GET /check_codes/1
  # GET /check_codes/1.json
  def show
    @check_code = CheckCode.first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_code }
    end
  end

  # GET /check_codes/new
  # GET /check_codes/new.json
  def new
    @check_code = CheckCode.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_code }
    end
  end

  # GET /check_codes/1/edit
  def edit
    @check_code = CheckCode.find(params[:id])
    @text = params[:text]
  end

  # POST /check_codes
  # POST /check_codes.json
  def create
    @check_code = CheckCode.new(params[:check_code])

    respond_to do |format|
      if @check_code.save
        format.html { redirect_to @check_code, notice: 'Check code was successfully created.' }
        format.json { render json: @check_code, status: :created, location: @check_code }
      else
        format.html { render action: "new" }
        format.json { render json: @check_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_codes/1
  # PUT /check_codes/1.json
  def update
    @check_code = CheckCode.find(params[:id])

    respond_to do |format|
      if @check_code.update_attributes(params[:check_code])
        format.html { redirect_to check_entries_path, notice: 'Check code was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_codes/1
  # DELETE /check_codes/1.json
  def destroy
    @check_code = CheckCode.find(params[:id])
    @check_code.destroy

    respond_to do |format|
      format.html { redirect_to check_codes_url }
      format.json { head :no_content }
    end
  end
end