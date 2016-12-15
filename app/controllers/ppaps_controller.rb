class PpapsController < ApplicationController
  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, Ppap
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_clerical? )
        authorize! :edit, Ppap
    end
  end

  def set_page_info
    @menus[:quality][:active] = "active"
    # simple_form_validation = false
  end
  # GET /ppaps
  # GET /ppaps.json
  def index
    @ppaps = Ppap.all

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @ppaps = @ppaps.select{|ppap|
          ppap[:id_link] = CommonActions.linkable(ppap_path(ppap), ppap.id)
          if can? :edit, ppap
            ppap[:lot_control_no] = CommonActions.linkable(quality_lot_path(ppap.quality_lot.id), ppap.quality_lot.lot_control_no)
            ppap[:links] = CommonActions.object_crud_paths(nil, edit_ppap_path(ppap), nil)
          else
            ppap[:lot_control_no] =  ppap.quality_lot.lot_control_no
            ppap[:links] = CommonActions.object_crud_paths(nil, nil, nil)
          end
        }
        render json: {:aaData => @ppaps}
      }
    end
  end

  # GET /ppaps/1
  # GET /ppaps/1.json
  def show
    @ppap = Ppap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ppap }
    end
  end

  # GET /ppaps/new
  # GET /ppaps/new.json
  def new
    @quality_lot = QualityLot.find(params[:quality_lot_id])
    @ppap = Ppap.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ppap }
    end
  end

  # GET /ppaps/1/edit
  def edit
    @ppap = Ppap.find(params[:id])
    @quality_lot = @ppap.quality_lot
  end

  # POST /ppaps
  # POST /ppaps.json
  def create
    pap = Ppap.process_ppap(params, "new")
    @ppap = Ppap.new(pap)
    respond_to do |format|
      if @ppap.save
        format.html { redirect_to @ppap, notice: 'PSW was successfully created.' }
        format.json { render json: @ppap, status: :created, location: @ppap }
      else
        format.html { render action: "new" }
        format.json { render json: @ppap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ppaps/1
  # PUT /ppaps/1.json
  def update
    @ppap = Ppap.find(params[:id])
    pap = Ppap.process_ppap(params,"update")
    respond_to do |format|
      if @ppap.update_attributes(pap)
        format.html { redirect_to @ppap, notice: 'PSW was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ppap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ppaps/1
  # DELETE /ppaps/1.json
  def destroy
    @ppap = Ppap.find(params[:id])
    @ppap.destroy

    respond_to do |format|
      format.html { redirect_to ppaps_url }
      format.json { head :no_content }
    end
  end
end
