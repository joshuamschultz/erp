class GaugesController < ApplicationController
  before_action :set_page_info
  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && current_user.is_customer?
      authorize! :edit, User
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics?  || current_user.is_clerical? || current_user.is_vendor? )
      authorize! :edit, Gauge
    end
  end

  def set_page_info
      @menus[:quality][:active] = "active" unless (params[:type] == "gauge").present?
      @menus[:reports][:active] = "active"  if (params[:type] == "gauge").present?
  end

  # GET /gauges
  # GET /gauges.json
  def index
    if(params[:type] == "gauge").present?
      @gauges = Gauge.get_this_week_gauges()
    else
      @gauges = Gauge.all
    end

    respond_to do |format|
      format.html # index.html.erb
      @gages = Array.new
      format.json{

        @gauges = @gauges.select{|gauge|
          gage = Hash.new
          gauge.attributes.each do |key, value|
            gage[key] = value
          end
          gage[:gauge_tool_name] = CommonActions.linkable(gauge_path(gauge), gauge[:gauge_tool_name])
          gage[:gauge_caliberator] = gauge.organization.present? ? CommonActions.linkable(organization_path(gauge.organization), gauge.organization.organization_short_name) : ""
          if can? :edit , gauge
            gage[:links] = params[:type].present? ? CommonActions.object_crud_paths(nil, nil, nil) : CommonActions.object_crud_paths(nil, edit_gauge_path(gauge), nil)
          else
             gage[:links] = CommonActions.object_crud_paths(nil, nil, nil)
          end
          @gages.push(gage)
        }
        render json: {:aaData => @gages}
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
    @gauge = Gauge.new(gauge_params)

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
      if @gauge.update_attributes(gauge_params)
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
  private

    def set_gauge
      @gauge = Gauge.find(params[:id])
    end

    def gauge_params
      params.require(:gauge).permit(:organization_id, :gage_caliberaion_period, :gage_caliberation_last_at, :gage_caliberation_due_at, :gauge_active, :gauge_created_id, :gauge_tool_name, :gauge_tool_no, :gauge_updated_id, :gauge_tool_category)
    end

end
