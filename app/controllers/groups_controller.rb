class GroupsController < ApplicationController
    # GET /groups
    # GET /groups.json
    before_filter :set_page_info

    def set_page_info
        # @menus[:groups][:active] = "active"
    end

    def index
        @groups = Group.all
        respond_to do |format|
            p "dfsdfsdf"
            format.html # index.html.erb
            format.json {
                @groups = @groups.select{|group|
                    group[:links] = CommonActions.object_crud_paths(nil, edit_group_path(group),nil)
                }
                render json: {:aaData => @groups}
            }
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
        @group = Group.new(params[:group])

        respond_to do |format|
            if @group.save
                Group.process_group_associations(@group, params)
                format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
                format.json { render json: @group, status: :created, location: @group }
            else
                format.html { render action: "new" }
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
            if @group.update_attributes(params[:group])
                format.html { redirect_to groups_path, notice: 'Group was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
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
end