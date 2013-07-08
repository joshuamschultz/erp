class TestPackagesController < ApplicationController
  # GET /test_packages
  # GET /test_packages.json
  def index
    @test_packages = TestPackage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_packages }
    end
  end

  # GET /test_packages/1
  # GET /test_packages/1.json
  def show
    @test_package = TestPackage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @test_package }
    end
  end

  # GET /test_packages/new
  # GET /test_packages/new.json
  def new
    @test_package = TestPackage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_package }
    end
  end

  # GET /test_packages/1/edit
  def edit
    @test_package = TestPackage.find(params[:id])
  end

  # POST /test_packages
  # POST /test_packages.json
  def create
    @test_package = TestPackage.new(params[:test_package])

    respond_to do |format|
      if @test_package.save
        format.html { redirect_to @test_package, notice: 'Test package was successfully created.' }
        format.json { render json: @test_package, status: :created, location: @test_package }
      else
        format.html { render action: "new" }
        format.json { render json: @test_package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /test_packages/1
  # PUT /test_packages/1.json
  def update
    @test_package = TestPackage.find(params[:id])

    respond_to do |format|
      if @test_package.update_attributes(params[:test_package])
        format.html { redirect_to @test_package, notice: 'Test package was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test_package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_packages/1
  # DELETE /test_packages/1.json
  def destroy
    @test_package = TestPackage.find(params[:id])
    @test_package.destroy

    respond_to do |format|
      format.html { redirect_to test_packages_url }
      format.json { head :no_content }
    end
  end
end
