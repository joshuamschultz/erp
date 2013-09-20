class ReceivablesController < ApplicationController
  # GET /receivables
  # GET /receivables.json
  def index
    @receivables = Receivable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @receivables }
    end
  end

  # GET /receivables/1
  # GET /receivables/1.json
  def show
    @receivable = Receivable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @receivable }
    end
  end

  # GET /receivables/new
  # GET /receivables/new.json
  def new
    @receivable = Receivable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @receivable }
    end
  end

  # GET /receivables/1/edit
  def edit
    @receivable = Receivable.find(params[:id])
  end

  # POST /receivables
  # POST /receivables.json
  def create
    @receivable = Receivable.new(params[:receivable])

    respond_to do |format|
      if @receivable.save
        format.html { redirect_to @receivable, notice: 'Receivable was successfully created.' }
        format.json { render json: @receivable, status: :created, location: @receivable }
      else
        format.html { render action: "new" }
        format.json { render json: @receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /receivables/1
  # PUT /receivables/1.json
  def update
    @receivable = Receivable.find(params[:id])

    respond_to do |format|
      if @receivable.update_attributes(params[:receivable])
        format.html { redirect_to @receivable, notice: 'Receivable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivables/1
  # DELETE /receivables/1.json
  def destroy
    @receivable = Receivable.find(params[:id])
    @receivable.destroy

    respond_to do |format|
      format.html { redirect_to receivables_url }
      format.json { head :no_content }
    end
  end
end
