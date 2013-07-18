class CustomerQualitiesController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:system][:active] = "active"
  end
  
  # GET /customer_qualities
  # GET /customer_qualities.json
  def index
      @customer_qualities = CustomerQuality.all

      respond_to do |format|
          format.html # index.html.erb
          format.json { 

            @customer_qualities = @customer_qualities.select{|quality| 
              quality[:links] = CommonActions.object_crud_paths(customer_quality_path(quality), edit_customer_quality_path(quality), 
              customer_quality_path(quality), [{:name => "Duplicate", :path => new_customer_quality_path(:quality_id => quality.id)}])
            }

            render json: {:aaData => @customer_qualities} 
          }
      end
  end

  # GET /customer_qualities/1
  # GET /customer_qualities/1.json
  def show
    @customer_quality = CustomerQuality.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_quality }
    end
  end

  # GET /customer_qualities/new
  # GET /customer_qualities/new.json
  def new
    @duplicate = CustomerQuality.find_by_id(params[:quality_id])
    @customer_quality = @duplicate.present? ? @duplicate.dup : CustomerQuality.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_quality }
    end
  end

  # GET /customer_qualities/1/edit
  def edit
    @customer_quality = CustomerQuality.find(params[:id])
  end

  # POST /customer_qualities
  # POST /customer_qualities.json
  def create
    @customer_quality = CustomerQuality.new(params[:customer_quality])

    respond_to do |format|
      if @customer_quality.save
        format.html { redirect_to @customer_quality, notice: 'Customer quality was successfully created.' }
        format.json { render json: @customer_quality, status: :created, location: @customer_quality }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customer_qualities/1
  # PUT /customer_qualities/1.json
  def update
    @customer_quality = CustomerQuality.find(params[:id])

    respond_to do |format|
      if @customer_quality.update_attributes(params[:customer_quality])
        format.html { redirect_to @customer_quality, notice: 'Customer quality was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_qualities/1
  # DELETE /customer_qualities/1.json
  def destroy
    @customer_quality = CustomerQuality.find(params[:id])
    @customer_quality.destroy

    respond_to do |format|
      format.html { redirect_to customer_qualities_url }
      format.json { head :no_content }
    end
  end
end
