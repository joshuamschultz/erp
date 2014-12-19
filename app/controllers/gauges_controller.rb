class GaugesController < ApplicationController
  before_filter :set_page_info
  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, User
    end 
  end

  def user_permissions
   if  user_signed_in? && (current_user.is_logistics?  || current_user.is_clerical? )
        authorize! :edit, User
    end 
  end

  def set_page_info
      @menus[:quality][:active] = "active"
  end

  # GET /gauges
  # GET /gauges.json  
  def index
    @gauges = Gauge.all
    respond_to do |format|
      format.html # index.html.erb
      format.json{
        @gauges = @gauges.select{|gauge|
          gauge[:gauge_tool_name] = CommonActions.linkable(gauge_path(gauge), gauge[:gauge_tool_name])
          gauge[:gauge_caliberator] = gauge.organization.present? ? CommonActions.linkable(organization_path(gauge.organization), gauge.organization.organization_short_name) : "" 
          gauge[:links] = CommonActions.object_crud_paths(nil, edit_gauge_path(gauge), nil)
        }
        render json: {:aaData => @gauges}
      }
    end
  end

  # GET /gauges/1
  # GET /gauges/1.json
  def show
    @gauge = Gauge.find(params[:id])
    @attachable = @gauge

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
        format.html { redirect_to gauges_path, notice: 'Instrument was successfully created.' }
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
        format.html { redirect_to gauges_path, notice: 'Instrument was successfully updated.' }
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
      format.html { redirect_to gauges_path, notice: 'Instrument was successfully deleted.'}
      format.json { head :no_content }
    end
  end
end
