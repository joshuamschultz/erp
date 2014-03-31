class CustomerQualityLevelsController < ApplicationController
  # GET /customer_quality_levels
  # GET /customer_quality_levels.json
  def index
    @customer_quality_levels = CustomerQualityLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customer_quality_levels }
    end
  end

  # GET /customer_quality_levels/1
  # GET /customer_quality_levels/1.json
  def show
    @customer_quality_level = CustomerQualityLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_quality_level }
    end
  end

  # GET /customer_quality_levels/new
  # GET /customer_quality_levels/new.json
  def new
    @customer_quality_level = CustomerQualityLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_quality_level }
    end
  end

  # GET /customer_quality_levels/1/edit
  def edit
    @customer_quality_level = CustomerQualityLevel.find(params[:id])
  end

  # POST /customer_quality_levels
  # POST /customer_quality_levels.json
  def create
    @customer_quality_level = CustomerQualityLevel.new(params[:customer_quality_level])

    respond_to do |format|
      if @customer_quality_level.save
        format.html { redirect_to @customer_quality_level, notice: 'Customer quality level was successfully created.' }
        format.json { render json: @customer_quality_level, status: :created, location: @customer_quality_level }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_quality_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customer_quality_levels/1
  # PUT /customer_quality_levels/1.json
  def update
    @customer_quality_level = CustomerQualityLevel.find(params[:id])

    respond_to do |format|
      if @customer_quality_level.update_attributes(params[:customer_quality_level])
        format.html { redirect_to @customer_quality_level, notice: 'Customer quality level was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_quality_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_quality_levels/1
  # DELETE /customer_quality_levels/1.json
  def destroy
    @customer_quality_level = CustomerQualityLevel.find(params[:id])
    @customer_quality_level.destroy

    respond_to do |format|
      format.html { redirect_to customer_quality_levels_url }
      format.json { head :no_content }
    end
  end
end
