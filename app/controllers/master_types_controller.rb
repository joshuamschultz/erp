class MasterTypesController < ApplicationController
  # GET /master_types
  # GET /master_types.json
  def index
      @master_types = MasterType.all

      respond_to do |format|
        format.html # index.html.erb
        format.json {

          @master_types = @master_types.select{|master_type|
              master_type[:links] = CommonActions.object_crud_paths(nil, edit_master_type_path(master_type),
              master_type_path(master_type))
          }
          render json: {:aaData => @master_types}
        }
      end
  end

  # GET /master_types/1
  # GET /master_types/1.json
  def show
    @master_type = MasterType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @master_type }
    end
  end

  # GET /master_types/new
  # GET /master_types/new.json
  def new
    @master_type = MasterType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @master_type }
    end
  end

  # GET /master_types/1/edit
  def edit
    @master_type = MasterType.find(params[:id])
  end

  # POST /master_types
  # POST /master_types.json
  def create
    @master_type = MasterType.new(master_type_params)

    respond_to do |format|
      if @master_type.save
        format.html { redirect_to master_types_url, notice: 'Master type was successfully created.' }
        format.json { render json: @master_type, status: :created, location: @master_type }
      else
        format.html { render action: "new" }
        format.json { render json: @master_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /master_types/1
  # PUT /master_types/1.json
  def update
    @master_type = MasterType.find(params[:id])

    respond_to do |format|
      if @master_type.update_attributes(master_type_params)
        format.html { redirect_to master_types_url, notice: 'Master type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @master_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_types/1
  # DELETE /master_types/1.json
  def destroy
    @master_type = MasterType.find(params[:id])
    @master_type.destroy

    respond_to do |format|
      format.html { redirect_to master_types_url }
      format.json { head :no_content }
    end
  end
  private

    def set_master_type
      @master_type = MasterType.find(params[:id])
    end

    def master_type_params
      params.require(:master_type).permit(:type_active, :type_category, :type_description, :type_name, :type_value, :quality_document_id)
    end
end
