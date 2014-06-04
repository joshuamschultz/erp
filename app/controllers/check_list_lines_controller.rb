class CheckListLinesController < ApplicationController
  # GET /check_list_lines
  # GET /check_list_lines.json
  def index
    @check_list_lines = CheckListLine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @check_list_lines }
    end
  end

  # GET /check_list_lines/1
  # GET /check_list_lines/1.json
  def show
    @check_list_line = CheckListLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_list_line }
    end
  end

  # GET /check_list_lines/new
  # GET /check_list_lines/new.json
  def new
    @check_list_line = CheckListLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_list_line }
    end
  end

  # GET /check_list_lines/1/edit
  def edit
    @check_list_line = CheckListLine.find(params[:id])
  end

  # POST /check_list_lines
  # POST /check_list_lines.json
  def create
    @check_list_line = CheckListLine.new(params[:check_list_line])

    respond_to do |format|
      if @check_list_line.save
        format.html { redirect_to @check_list_line, notice: 'Check list line was successfully created.' }
        format.json { render json: @check_list_line, status: :created, location: @check_list_line }
      else
        format.html { render action: "new" }
        format.json { render json: @check_list_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_list_lines/1
  # PUT /check_list_lines/1.json
  def update
    @check_list_line = CheckListLine.find(params[:id])

    respond_to do |format|
      if @check_list_line.update_attributes(params[:check_list_line])
        format.html { redirect_to @check_list_line, notice: 'Check list line was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_list_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_list_lines/1
  # DELETE /check_list_lines/1.json
  def destroy
    @check_list_line = CheckListLine.find(params[:id])
    @check_list_line.destroy

    respond_to do |format|
      format.html { redirect_to check_list_lines_url }
      format.json { head :no_content }
    end
  end
end
