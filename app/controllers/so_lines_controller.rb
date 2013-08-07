class SoLinesController < ApplicationController
  # GET /so_lines
  # GET /so_lines.json
  def index
    @so_lines = SoLine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @so_lines }
    end
  end

  # GET /so_lines/1
  # GET /so_lines/1.json
  def show
    @so_line = SoLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @so_line }
    end
  end

  # GET /so_lines/new
  # GET /so_lines/new.json
  def new
    @so_line = SoLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @so_line }
    end
  end

  # GET /so_lines/1/edit
  def edit
    @so_line = SoLine.find(params[:id])
  end

  # POST /so_lines
  # POST /so_lines.json
  def create
    @so_line = SoLine.new(params[:so_line])

    respond_to do |format|
      if @so_line.save
        format.html { redirect_to @so_line, notice: 'So line was successfully created.' }
        format.json { render json: @so_line, status: :created, location: @so_line }
      else
        format.html { render action: "new" }
        format.json { render json: @so_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /so_lines/1
  # PUT /so_lines/1.json
  def update
    @so_line = SoLine.find(params[:id])

    respond_to do |format|
      if @so_line.update_attributes(params[:so_line])
        format.html { redirect_to @so_line, notice: 'So line was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @so_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /so_lines/1
  # DELETE /so_lines/1.json
  def destroy
    @so_line = SoLine.find(params[:id])
    @so_line.destroy

    respond_to do |format|
      format.html { redirect_to so_lines_url }
      format.json { head :no_content }
    end
  end
end
