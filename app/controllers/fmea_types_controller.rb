class FmeaTypesController < ApplicationController
  # GET /fmea_types
  # GET /fmea_types.json
  def index
    @fmea_types = FmeaType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fmea_types }
    end
  end

  # GET /fmea_types/1
  # GET /fmea_types/1.json
  def show
    @fmea_type = FmeaType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fmea_type }
    end
  end

  # GET /fmea_types/new
  # GET /fmea_types/new.json
  def new
    @fmea_type = FmeaType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fmea_type }
    end
  end

  # GET /fmea_types/1/edit
  def edit
    @fmea_type = FmeaType.find(params[:id])
  end

  # POST /fmea_types
  # POST /fmea_types.json
  def create
    @fmea_type = FmeaType.new(params[:fmea_type])

    respond_to do |format|
      if @fmea_type.save
        format.html { redirect_to @fmea_type, notice: 'Fmea type was successfully created.' }
        format.json { render json: @fmea_type, status: :created, location: @fmea_type }
      else
        format.html { render action: "new" }
        format.json { render json: @fmea_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fmea_types/1
  # PUT /fmea_types/1.json
  def update
    @fmea_type = FmeaType.find(params[:id])

    respond_to do |format|
      if @fmea_type.update_attributes(params[:fmea_type])
        format.html { redirect_to @fmea_type, notice: 'Fmea type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fmea_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fmea_types/1
  # DELETE /fmea_types/1.json
  def destroy
    @fmea_type = FmeaType.find(params[:id])
    @fmea_type.destroy

    respond_to do |format|
      format.html { redirect_to fmea_types_url }
      format.json { head :no_content }
    end
  end
end
