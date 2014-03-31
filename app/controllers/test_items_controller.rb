class TestItemsController < ApplicationController
  # GET /test_items
  # GET /test_items.json
  def index
    if params[:test_package_id]
        @test_package = TestPackage.find_by_id(params[:test_package_id])
        @test_items = @test_package.test_items.all
    else
        @test_items = TestItem.all
    end

    respond_to do |format|
      format.html { render layout: false } # index.html.erb
      format.json { render json: @test_items }
    end
  end

  # GET /test_items/1
  # GET /test_items/1.json
  def show
    @test_item = TestItem.find(params[:id])

    respond_to do |format|
      format.html { render layout: false } # show.html.erb
      format.json { render json: @test_item }
    end
  end

  # GET /test_items/new
  # GET /test_items/new.json
  def new    
    @test_package = TestPackage.find_by_id(params[:test_package_id])
    @test_item = TestItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_item }
    end
  end

  # GET /test_items/1/edit
  def edit
    # puts "dsssssssssssssssssssssssssss"
    @test_item = TestItem.find(params[:id])    
  end

  # POST /test_items
  # POST /test_items.json
  def create
    @test_item = TestItem.new(params[:test_item])

    respond_to do |format|
      if @test_item.save
        format.html { redirect_to action: "new", :test_package_id => params[:test_item][:test_package_id], :layout => false, :notice => 'Test item was successfully created.'} #{ redirect_to @test_item, notice: 'Test item was successfully created.' }
        format.json { render json: @test_item, status: :created, location: @test_item }
      else
        format.html { render action: "new" }
        format.json { render json: @test_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /test_items/1
  # PUT /test_items/1.json
  def update
    @test_item = TestItem.find(params[:id])

    respond_to do |format|
      if @test_item.update_attributes(params[:test_item])
        format.html { redirect_to @test_item, notice: 'Test item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_items/1
  # DELETE /test_items/1.json
  def destroy
    @test_item = TestItem.find(params[:id])
    @test_item.destroy

    respond_to do |format|
      format.html { redirect_to test_items_url }
      format.json { head :no_content }
    end
  end
end
