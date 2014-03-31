class QuoteLineCostsController < ApplicationController
  # GET /quote_line_costs
  # GET /quote_line_costs.json
  def index
    @quote_line_costs = QuoteLineCost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quote_line_costs }
    end
  end

  # GET /quote_line_costs/1
  # GET /quote_line_costs/1.json
  def show
    @quote_line_cost = QuoteLineCost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote_line_cost }
    end
  end

  # GET /quote_line_costs/new
  # GET /quote_line_costs/new.json
  def new
    @quote_line_cost = QuoteLineCost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote_line_cost }
    end
  end

  # GET /quote_line_costs/1/edit
  def edit
    @quote_line_cost = QuoteLineCost.find(params[:id])
  end

  # POST /quote_line_costs
  # POST /quote_line_costs.json
  def create
    @quote_line_cost = QuoteLineCost.new(params[:quote_line_cost])

    respond_to do |format|
      if @quote_line_cost.save
        format.html { redirect_to @quote_line_cost, notice: 'Quote line cost was successfully created.' }
        format.json { render json: @quote_line_cost, status: :created, location: @quote_line_cost }
      else
        format.html { render action: "new" }
        format.json { render json: @quote_line_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quote_line_costs/1
  # PUT /quote_line_costs/1.json
  def update
    @quote_line_cost = QuoteLineCost.find(params[:id])

    respond_to do |format|
      if @quote_line_cost.update_attributes(params[:quote_line_cost])
        format.html { redirect_to @quote_line_cost, notice: 'Quote line cost was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote_line_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quote_line_costs/1
  # DELETE /quote_line_costs/1.json
  def destroy
    @quote_line_cost = QuoteLineCost.find(params[:id])
    @quote_line_cost.destroy

    respond_to do |format|
      format.html { redirect_to quote_line_costs_url }
      format.json { head :no_content }
    end
  end
end
