class QualityHistoriesController < ApplicationController
  # GET /quality_histories
  # GET /quality_histories.json
  def index
    @quality_histories = QualityHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quality_histories }
    end
  end

  # GET /quality_histories/1
  # GET /quality_histories/1.json
  def show
    @quality_history = QualityHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_history }
    end
  end

  # GET /quality_histories/new
  # GET /quality_histories/new.json
  def new
    @quality_history = QualityHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_history }
    end
  end

  # GET /quality_histories/1/edit
  def edit
    @quality_history = QualityHistory.find(params[:id])
  end

  # POST /quality_histories
  # POST /quality_histories.json
  def create
    @quality_history = QualityHistory.new(params[:quality_history])

    respond_to do |format|
      if @quality_history.save
        format.html { redirect_to @quality_history, notice: 'Quality history was successfully created.' }
        format.json { render json: @quality_history, status: :created, location: @quality_history }
      else
        format.html { render action: "new" }
        format.json { render json: @quality_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_histories/1
  # PUT /quality_histories/1.json
  def update
    @quality_history = QualityHistory.find(params[:id])

    respond_to do |format|
      if @quality_history.update_attributes(params[:quality_history])
        format.html { redirect_to @quality_history, notice: 'Quality history was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_histories/1
  # DELETE /quality_histories/1.json
  def destroy
    @quality_history = QualityHistory.find(params[:id])
    @quality_history.destroy

    respond_to do |format|
      format.html { redirect_to quality_histories_url }
      format.json { head :no_content }
    end
  end
end
