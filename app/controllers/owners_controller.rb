class OwnersController < ApplicationController
  before_filter :set_page_info

  def set_page_info
      @menus[:system][:active] = "active"
  end
  # GET /owners
  # GET /owners.json
  def index
    @owners = Owner.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @owners = @owners.select{|owner| 
          owner[:links] = CommonActions.object_crud_paths(owner_path(owner), edit_owner_path(owner), 
                        owner_path(owner))
          owner[:owner_commission_type] = owner.commission_type.type_name
          owner[:owner_commission_percentage] = owner.owner_commission_amount.to_s + "%"
        }
        render json: {:aaData => @owners} 
      }
    end
  end

  # GET /owners/1
  # GET /owners/1.json
  def show
    @owner = Owner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @owner }
    end
  end

  # GET /owners/new
  # GET /owners/new.json
  def new
    @duplicate = Owner.find_by_id(params[:owner_id])
    @owner = @duplicate.present? ? @duplicate.dup : Owner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @owner }
    end
  end

  # GET /owners/1/edit
  def edit
    @owner = Owner.find(params[:id])
  end

  # POST /owners
  # POST /owners.json
  def create
    @owner = Owner.new(params[:owner])

    respond_to do |format|
      if @owner.save
        format.html { redirect_to @owner, notice: 'Owner was successfully created.' }
        format.json { render json: @owner, status: :created, location: @owner }
      else
        format.html { render action: "new" }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /owners/1
  # PUT /owners/1.json
  def update
    @owner = Owner.find(params[:id])

    respond_to do |format|
      if @owner.update_attributes(params[:owner])
        format.html { redirect_to @owner, notice: 'Owner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.json
  def destroy
    @owner = Owner.find(params[:id])
    @owner.destroy

    respond_to do |format|
      format.html { redirect_to owners_url }
      format.json { head :no_content }
    end
  end
end
