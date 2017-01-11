class PrivilegesController < ApplicationController

  before_action :manager_permissions,  :except => :index
  before_action :user_permissions


  def manager_permissions
    if  user_signed_in? && current_user.is_manager?
        authorize! :edit, User
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_logistics? || current_user.is_quality? || current_user.is_operations? || current_user.is_clerical?  || current_user.is_vendor? || current_user.is_customer?  )
        authorize! :edit, User
    end
  end





# include Devise::Controllers::InternalHelpers
  # GET /users
  # GET /users.json
  def index
    @users = User.where("id != ?", current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      @usrs = Array.new
      format.json {
         @users = @users.select{ |user|
          usr = Hash.new
          user.attributes.each do |key, value|
            usr[key] = value
          end
          usr[:user_email] = "<a href='mailto:#{user.email}' target='_top'>#{user.email}</a>"
          if can? :edit, user
            usr[:user_name] = "<a href='#{privilege_path(user)}'>#{user.name}</a>"
            usr[:links] = CommonActions.object_crud_paths(nil, edit_privilege_path(user), nil)
          else
            usr[:user_name] = user.name
            usr[:links] = CommonActions.object_crud_paths(nil,nil, nil)
          end
          usr[:role] = user.role_symbols[0].to_s
          @usrs.push(usr)
        }
        render json: {:aaData => @usrs}
      }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.roles = [params[:role]]
    password_temp = password = Devise.friendly_token.first(8)
    p password

    @user.password = password_temp
    @user.password_confirmation = password_temp

    enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now

    respond_to do |format|
      if @user.save
        User.user_organizations_associations(@user, params)
        # @user.send_reset_password_instructions
        UserMailer.welcome_email(@user).deliver
        format.html { redirect_to privileges_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(params[:id])
    @user.roles = [params[:role]]
    respond_to do |format|
      if @user.update_attributes(user_params)
        User.user_organizations_associations(@user, params)
        format.html { redirect_to privileges_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    # if @user.update_attributes(params[:user])
    #    redirect_to privileges_path
    # end
    # @user = User.find(params[:id])
    # params[:user].delete(:current_password)
    # @user.update_without_password(params[:user])
    # redirect_to privileges_path
    # respond_to do |format|
    #   if @user.update_attributes(params[:user])
    #     format.html { redirect_to privileges_path, notice: 'User was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to privileges_path, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  private
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :organization_attributes,
      :name, :gender, :address, :city, :state, :country, :telephone_no, :mobile_no, :active, :roles_mask, :organization_id, :time_zone)
    end

end
