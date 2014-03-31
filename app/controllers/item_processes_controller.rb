class ItemProcessesController < ApplicationController
  # GET /item_processes
  # GET /item_processes.json
  def index
    @item_processes = ItemProcess.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_processes }
    end
  end

  # GET /item_processes/1
  # GET /item_processes/1.json
  def show
    @item_process = ItemProcess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_process }
    end
  end

  # GET /item_processes/new
  # GET /item_processes/new.json
  def new
    @item_process = ItemProcess.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_process }
    end
  end

  # GET /item_processes/1/edit
  def edit
    @item_process = ItemProcess.find(params[:id])
  end

  # POST /item_processes
  # POST /item_processes.json
  def create
    @item_process = ItemProcess.new(params[:item_process])

    respond_to do |format|
      if @item_process.save
        format.html { redirect_to @item_process, notice: 'Item process was successfully created.' }
        format.json { render json: @item_process, status: :created, location: @item_process }
      else
        format.html { render action: "new" }
        format.json { render json: @item_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_processes/1
  # PUT /item_processes/1.json
  def update
    @item_process = ItemProcess.find(params[:id])

    respond_to do |format|
      if @item_process.update_attributes(params[:item_process])
        format.html { redirect_to @item_process, notice: 'Item process was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_processes/1
  # DELETE /item_processes/1.json
  def destroy
    @item_process = ItemProcess.find(params[:id])
    @item_process.destroy

    respond_to do |format|
      format.html { redirect_to item_processes_url }
      format.json { head :no_content }
    end
  end
end
