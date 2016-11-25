class RunAtRatesController < ApplicationController
  before_filter :set_page_info
  autocomplete :run_at_rate, :run_at_rate_name, :full => true
  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, RunAtRate
    end 
  end

  def user_permissions
   if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? )
        authorize! :edit, RunAtRate
    end 
  end
  def set_page_info
    @menus[:quality][:active] = "active"
  end
  # GET /run_at_rates
  # GET /run_at_rates.json
  def index
    @run_at_rates = RunAtRate.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @run_at_rates = @run_at_rates.collect{|run_at_rate| 
          attachment = run_at_rate.attachment.attachment_fields
          attachment[:attachment_name] = CommonActions.linkable(run_at_rate_path(run_at_rate), attachment.attachment_name)
          if can? :edit, run_at_rate
            attachment[:links] = CommonActions.object_crud_paths(nil, edit_run_at_rate_path(run_at_rate), nil)
          else
            attachment[:links] = CommonActions.object_crud_paths(nil, nil, nil)
          end
          attachment
        }
        render json: {:aaData => @run_at_rates} 
      }
    end
  end

  # GET /run_at_rates/1
  # GET /run_at_rates/1.json
  def show
    @run_at_rate = RunAtRate.find(params[:id])
    @attachment = @run_at_rate.attachment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @run_at_rate }
    end
  end

  # GET /run_at_rates/new
  # GET /run_at_rates/new.json
  def new
    @run_at_rate = RunAtRate.new
    @run_at_rate.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @run_at_rate }
    end
  end

  # GET /run_at_rates/1/edit
  def edit
    @run_at_rate = RunAtRate.find(params[:id])
    @attachment = @run_at_rate.attachment

  end

  # POST /run_at_rates
  # POST /run_at_rates.json
  def create
    @run_at_rate = RunAtRate.new(params[:run_at_rate])

    respond_to do |format|
      @run_at_rate.attachment.created_by = current_user
      if @run_at_rate.save
        format.html { redirect_to run_at_rates_url, notice: 'Run at rate was successfully created.' }
        format.json { render json: @run_at_rate, status: :created, location: @run_at_rate }
      else
        format.html { render action: "new" }
        format.json { render json: @run_at_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /run_at_rates/1
  # PUT /run_at_rates/1.json
  def update
    @run_at_rate = RunAtRate.find(params[:id])

    respond_to do |format|
      @run_at_rate.attachment.updated_by = current_user

      if @run_at_rate.update_attributes(params[:run_at_rate])
        format.html { redirect_to run_at_rates_url, notice: 'Run at rate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @run_at_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /run_at_rates/1
  # DELETE /run_at_rates/1.json
  def destroy
    @run_at_rate = RunAtRate.find(params[:id])
    @run_at_rate.destroy

    respond_to do |format|
      format.html { redirect_to run_at_rates_url }
      format.json { head :no_content }
    end
  end
  
  private

    def set_run_at_rate
      @run_at_rate = RunAtRate.find(params[:id])
    end

    def run_at_rate_params
      params.require(:run_at_rate).permit(:run_at_rate_active, :run_at_rate_created_id, :run_at_rate_description, 
                                          :run_at_rate_name, :run_at_rate_notes, :run_at_rate_updated_id,:attachment_attributes)
    end
end
