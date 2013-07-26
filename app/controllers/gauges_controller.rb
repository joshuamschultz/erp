class GaugesController < ApplicationController
  # GET /gauges
  # GET /gauges.json
  def index
    @gauges = Gauge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gauges }
    end
  end

  # GET /gauges/1
  # GET /gauges/1.json
  def show
    @gauge = Gauge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gauge }
    end
  end

  # GET /gauges/new
  # GET /gauges/new.json
  def new
    @gauge = Gauge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gauge }
    end
  end

  # GET /gauges/1/edit
  def edit
    @gauge = Gauge.find(params[:id])
  end

  # POST /gauges
  # POST /gauges.json
  def create
    @gauge = Gauge.new(params[:gauge])

    respond_to do |format|
      if @gauge.save
        format.html { redirect_to @gauge, notice: 'Gauge was successfully created.' }
        format.json { render json: @gauge, status: :created, location: @gauge }
      else
        format.html { render action: "new" }
        format.json { render json: @gauge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gauges/1
  # PUT /gauges/1.json
  def update
    @gauge = Gauge.find(params[:id])

    respond_to do |format|
      if @gauge.update_attributes(params[:gauge])
        format.html { redirect_to @gauge, notice: 'Gauge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gauge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gauges/1
  # DELETE /gauges/1.json
  def destroy
    @gauge = Gauge.find(params[:id])
    @gauge.destroy

    respond_to do |format|
      format.html { redirect_to gauges_url }
      format.json { head :no_content }
    end
  end
end
