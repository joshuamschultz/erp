class PrivilegesController < ApplicationController
# include Devise::Controllers::InternalHelpers
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
      	 @users = @users.select{ |user| 
          user[:show] = "<a href='#{privilege_path(user)}'>#{user.name}</a>"
          user[:links] = CommonActions.object_crud_paths(nil, edit_privilege_path(user), nil)
        }
        render json: {:aaData => @users}
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
    @user = User.new(params[:user])
    password_temp = password = Devise.friendly_token.first(8)
    @user.password = password_temp
    @user.password_confirmation = password_temp
	@user.reset_password_token= User.reset_password_token 

    respond_to do |format|
      if @user.save
      	@user.send_reset_password_instructions
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
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to privileges_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
end
