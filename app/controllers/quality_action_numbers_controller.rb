class QualityActionNumbersController < ApplicationController
  before_filter :set_page_info
  def set_page_info
    @menus[:system][:active] = "active"
  end
  # GET /quality_action_numbers
  # GET /quality_action_numbers.json
  def index
    @quality_action_numbers = QualityActionNumber.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quality_action_numbers }
    end
  end

  # GET /quality_action_numbers/1
  # GET /quality_action_numbers/1.json
  def show
    @quality_action_number = QualityActionNumber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_action_number }
    end
  end

  # GET /quality_action_numbers/new
  # GET /quality_action_numbers/new.json
  def new
    @quality_action_number = QualityActionNumber.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_action_number }
    end
  end

  # GET /quality_action_numbers/1/edit
  def edit
    @quality_action_number = QualityActionNumber.find(params[:id])
  end

  # POST /quality_action_numbers
  # POST /quality_action_numbers.json
  def create
    @quality_action_number = QualityActionNumber.new(params[:quality_action_number])

    respond_to do |format|
      if @quality_action_number.save
        format.html { redirect_to @quality_action_number, notice: 'Quality action number was successfully created.' }
        format.json { render json: @quality_action_number, status: :created, location: @quality_action_number }
      else
        format.html { render action: "new" }
        format.json { render json: @quality_action_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_action_numbers/1
  # PUT /quality_action_numbers/1.json
  def update
    @quality_action_number = QualityActionNumber.find(params[:id])

    respond_to do |format|
      if @quality_action_number.update_attributes(params[:quality_action_number])
        format.html { redirect_to @quality_action_number, notice: 'Quality action number was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_action_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_action_numbers/1
  # DELETE /quality_action_numbers/1.json
  def destroy
    @quality_action_number = QualityActionNumber.find(params[:id])
    @quality_action_number.destroy

    respond_to do |format|
      format.html { redirect_to quality_action_numbers_url }
      format.json { head :no_content }
    end
  end
end
