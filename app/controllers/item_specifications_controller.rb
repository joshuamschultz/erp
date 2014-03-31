class ItemSpecificationsController < ApplicationController
  # GET /item_specifications
  # GET /item_specifications.json
  def index
    @item_specifications = ItemSpecification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_specifications }
    end
  end

  # GET /item_specifications/1
  # GET /item_specifications/1.json
  def show
    @item_specification = ItemSpecification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_specification }
    end
  end

  # GET /item_specifications/new
  # GET /item_specifications/new.json
  def new
    @item_specification = ItemSpecification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_specification }
    end
  end

  # GET /item_specifications/1/edit
  def edit
    @item_specification = ItemSpecification.find(params[:id])
  end

  # POST /item_specifications
  # POST /item_specifications.json
  def create
    @item_specification = ItemSpecification.new(params[:item_specification])

    respond_to do |format|
      if @item_specification.save
        format.html { redirect_to @item_specification, notice: 'Item specification was successfully created.' }
        format.json { render json: @item_specification, status: :created, location: @item_specification }
      else
        format.html { render action: "new" }
        format.json { render json: @item_specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_specifications/1
  # PUT /item_specifications/1.json
  def update
    @item_specification = ItemSpecification.find(params[:id])

    respond_to do |format|
      if @item_specification.update_attributes(params[:item_specification])
        format.html { redirect_to @item_specification, notice: 'Item specification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_specifications/1
  # DELETE /item_specifications/1.json
  def destroy
    @item_specification = ItemSpecification.find(params[:id])
    @item_specification.destroy

    respond_to do |format|
      format.html { redirect_to item_specifications_url }
      format.json { head :no_content }
    end
  end
end
