class GroupsController < ApplicationController
  before_action :set_page_info

  def set_page_info
    @menus[:contacts][:active] = 'active'
  end

  def index
    @groups = Group.all
    @grups = []
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        @groups = @groups.select do |group|
          grup = {}
          group.attributes.each do |key, value|
            grup[key] = value
          end
          grup[:org_names] = group.org_names
          grup[:group_name] = CommonActions.linkable(group_path(group), group.group_name)
          grup[:links] = CommonActions.object_crud_paths(nil, edit_group_path(group), nil)
          @grups.push(grup)
        end
        render json: { aaData: @grups }
      end
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        Group.process_group_associations(@group, params)
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      Group.process_group_associations(@group, params)
      if @group.update_attributes(group_params)
        format.html { redirect_to groups_path, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:group_name, :group_type)
  end
end
