class LogosController < ApplicationController
  # GET /logos
  # GET /logos.json
  def index
    @logos = Logo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logos }
    end
  end

  # GET /logos/1
  # GET /logos/1.json
  def show
    @logo = Logo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @logo }
    end
  end

  # GET /logos/new
  # GET /logos/new.json
  def new
    @object = Organization.new
    @logo = Logo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @logo }
    end
  end

  # GET /logos/1/edit
  def edit
    @logo = Logo.find(params[:id])
  end

  # POST /logos
  # POST /logos.json
  def create
    @logo = Logo.new(logo_params)

    respond_to do |format|
      if @logo.save
        format.html { redirect_to @logo, notice: 'Logo was successfully created.' }
        format.json { render json: @logo, status: :created, location: @logo }
      else
        format.html { render action: "new" }
        format.json { render json: @logo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /logos/1
  # PUT /logos/1.json
  def update
    @logo = Logo.find(params[:id])

    respond_to do |format|
      if @logo.update_attributes(logo_params)
        format.html { redirect_to @logo, notice: 'Logo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @logo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logos/1
  # DELETE /logos/1.json
  def destroy
    @logo = Logo.find(params[:id])
    @logo.destroy

    respond_to do |format|
      format.html { redirect_to logos_url }
      format.json { head :no_content }
    end
  end
  private

      def set_logo
        @logo = Logo.find(params[:id])
      end

      def logo_params
        params.require(:logo).permit(:joint_active, :joint_content_type, :joint_created_id, :joint_description,
                                     :joint_file_name, :joint_file_size, :joint_notes, :joint_public, :joint_title, :joint_updated_id,
                                     :jointable_id, :jointable_type, :joint)
      end
end
