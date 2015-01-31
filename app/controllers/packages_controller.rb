class PackagesController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]
  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_logistics? || current_user.is_vendor? || current_user.is_customer?)
        authorize! :edit, Package
    end 
  end

  def user_permissions
   if  user_signed_in? && current_user.is_clerical? 
        authorize! :edit, Package
    end 
  end

  def set_autocomplete_values
    params[:package][:quality_lot_id], params[:quality_lot_id] = params[:quality_lot_id], params[:package][:quality_lot_id]
    params[:package][:quality_lot_id] = params[:org_quality_lot_id] if params[:package][:quality_lot_id] == ""
  end

  def set_page_info
      @menus[:quality][:active] = "active"
      simple_form_validation = false
  end

  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
         @packages = @packages.select{|package|
            if can? :edit , package
              package[:links] = CommonActions.object_crud_paths(nil, edit_package_path(package), nil)
            else
              package[:links] = ""
            end
            package[:id_link] = CommonActions.linkable(package_path(package), package.id)
           
            if can? :view , Package
              package[:lot_control_no] = CommonActions.linkable(quality_lot_path(package.quality_lot), package.quality_lot.lot_control_no)
            end

        }
        render json: {:aaData => @packages}
      }
    end
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
    @package = Package.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @package }
    end
  end

  # GET /packages/new
  # GET /packages/new.json
  def new
    @package = Package.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @package }
    end
  end

  # GET /packages/1/edit
  def edit
    @package = Package.find(params[:id])
  end

  # POST /packages
  # POST /packages.json
  def create
    @package = Package.new(params[:package])

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, notice: 'Package was successfully created.' }
        format.json { render json: @package, status: :created, location: @package }
      else
        format.html { render action: "new" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /packages/1
  # PUT /packages/1.json
  def update
    @package = Package.find(params[:id])

    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html { redirect_to @package, notice: 'Package was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      format.html { redirect_to packages_url }
      format.json { head :no_content }
    end
  end
end
