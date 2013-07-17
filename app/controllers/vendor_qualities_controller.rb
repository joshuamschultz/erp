class VendorQualitiesController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:system][:active] = "active"
  end
  
  # GET /vendor_qualities
  # GET /vendor_qualities.json
  def index
    @vendor_qualities = VendorQuality.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @vendor_qualities = @vendor_qualities.select{|quality| 
          quality[:links] = CommonActions.object_crud_paths(vendor_quality_path(quality), edit_vendor_quality_path(quality), 
                        vendor_quality_path(quality), [{:name => "Duplicate", :path => new_vendor_quality_path(:quality_id => quality.id)}])
        }

        render json: {:aaData => @vendor_qualities} 
      }
    end
  end

  # GET /vendor_qualities/1
  # GET /vendor_qualities/1.json
  def show
    @vendor_quality = VendorQuality.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendor_quality }
    end
  end

  # GET /vendor_qualities/new
  # GET /vendor_qualities/new.json
  def new
    @duplicate = VendorQuality.find_by_id(params[:quality_id])
    @vendor_quality = @duplicate.present? ? @duplicate.dup : VendorQuality.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendor_quality }
    end
  end

  # GET /vendor_qualities/1/edit
  def edit
    @vendor_quality = VendorQuality.find(params[:id])
  end

  # POST /vendor_qualities
  # POST /vendor_qualities.json
  def create
    @vendor_quality = VendorQuality.new(params[:vendor_quality])

    respond_to do |format|
      if @vendor_quality.save
        format.html { redirect_to @vendor_quality, notice: 'Vendor quality was successfully created.' }
        format.json { render json: @vendor_quality, status: :created, location: @vendor_quality }
      else
        format.html { render action: "new" }
        format.json { render json: @vendor_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendor_qualities/1
  # PUT /vendor_qualities/1.json
  def update
    @vendor_quality = VendorQuality.find(params[:id])

    respond_to do |format|
      if @vendor_quality.update_attributes(params[:vendor_quality])
        format.html { redirect_to @vendor_quality, notice: 'Vendor quality was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendor_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendor_qualities/1
  # DELETE /vendor_qualities/1.json
  def destroy
    @vendor_quality = VendorQuality.find(params[:id])
    @vendor_quality.destroy

    respond_to do |format|
      format.html { redirect_to vendor_qualities_url }
      format.json { head :no_content }
    end
  end
end
