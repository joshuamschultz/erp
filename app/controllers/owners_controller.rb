class OwnersController < ApplicationController
  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_operations? || current_user.is_clerical? )
        authorize! :edit, User
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality?   || current_user.is_vendor? || current_user.is_customer?  )
        authorize! :edit, User
    end
  end



  def set_page_info
      @menus[:system][:active] = "active"
  end


  # GET /owners
  # GET /owners.json
  def index
    # query = search(Owner)
    # @owners = Owner.page(page).per(per_page)
    # if params[:sSearch].present?
    #     @owners = Owner.where(query, search: "%#{params[:sSearch]}%")
    # end

    @owners = Owner.all

    respond_to do |format|
      format.html # index.html.erb
      @ownrs = Array.new
      format.json {
        @owners = @owners.select{|owner|
          ownr = Hash.new
          owner.attributes.each do |key, value|
            ownr[key] = value
          end
          if can? :edit, owner
            ownr[:links] = CommonActions.object_crud_paths(owner_path(owner), edit_owner_path(owner),
                   owner_path(owner))
          else
            ownr[:links] = CommonActions.object_crud_paths(owner_path(owner), nil,
                   nil)
          end
          ownr[:owner_commission_type] = owner.commission_type.type_name
          ownr[:owner_commission_percentage] = owner.owner_commission_amount.to_s + "%"
          @ownrs.push(ownr)
        }
        render json: {:aaData => @ownrs}
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
    @owner = Owner.new(owner_params)

    respond_to do |format|
      if @owner.save
        format.html { redirect_to owners_url, notice: 'Owner was successfully created.' }
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
      if @owner.update_attributes(owner_params)
        format.html { redirect_to owners_url, notice: 'Owner was successfully updated.' }
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

# for datables searcha and paginaiton
  def search(model)
    tabel_model = model
    fields = tabel_model.column_names
    str = ""
    fields.each do |value|
        str += value+" like :search " if value == fields.last
        str += value+" like :search or " unless value == fields.last
    end
    str
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end
  private

    def set_owner
      @owner = Owner.find(params[:id])
    end

    def owner_params
      params.require(:owner).permit(:owner_commission_amount, :owner_commission_type_id, :owner_description,
                                    :owner_identifier, :owner_created_id, :owner_updated_id, :owner_active)
    end

end
