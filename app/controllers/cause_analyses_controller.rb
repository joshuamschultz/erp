class CauseAnalysesController < ApplicationController
  before_filter :set_page_info

  autocomplete :cause_analysis, :name, :full => true

  def set_page_info
    @menus[:quality][:active] = "active"
  end
  # GET /cause_analyses
  # GET /cause_analyses.json
  def index
    @cause_analyses = CauseAnalysis.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @cause_analyses = @cause_analyses.collect{|cause_analysis| 
          attachment = cause_analysis.attachment.attachment_fields
          attachment[:attachment_name] = CommonActions.linkable(cause_analyasis_path(cause_analysis), attachment.attachment_name)
          attachment[:links] = CommonActions.object_crud_paths(nil, edit_cause_analyasis_path(cause_analysis), nil)
          attachment
        }
        render json: {:aaData => @cause_analyses} 
      }
    end
  end

  # GET /cause_analyses/1
  # GET /cause_analyses/1.json
  def show
    @cause_analyasis = CauseAnalysis.find(params[:id])
    @attachment = @cause_analyasis.attachment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cause_analyasis }
    end
  end

  # GET /cause_analyses/new
  # GET /cause_analyses/new.json
  def new
    @cause_analyasis = CauseAnalysis.new()
    @cause_analyasis.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cause_analyasis }
    end
  end

  # GET /cause_analyses/1/edit
  def edit
    @cause_analyasis = CauseAnalysis.find(params[:id])
    @attachment = @cause_analyasis.attachment
  end

  # POST /cause_analyses
  # POST /cause_analyses.json
  def create
    @cause_analyasis = CauseAnalysis.new(params[:cause_analysis])

    respond_to do |format|
      p @cause_analyasis.attachment
      @cause_analyasis.attachment.created_by = current_user
      if @cause_analyasis.save
        format.html { redirect_to cause_analyses_path, notice: 'Cause analysis was successfully created.' }
        format.json { render json: @cause_analyasis, status: :created, location: @cause_analyasis }
      else
        format.html { render action: "new" }
        format.json { render json: @cause_analyasis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cause_analyses/1
  # PUT /cause_analyses/1.json
  def update
    @cause_analyasis = CauseAnalysis.find(params[:id])

    respond_to do |format|
      @cause_analyasis.attachment.updated_by = current_user
      if @cause_analyasis.update_attributes(params[:cause_analyasis])
        format.html { redirect_to cause_analyses_path, notice: 'Cause analysis was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cause_analyasis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cause_analyses/1
  # DELETE /cause_analyses/1.json
  def destroy
    @cause_analyasis = CauseAnalysis.find(params[:id])
    @cause_analyasis.destroy

    respond_to do |format|
      format.html { redirect_to cause_analyses_url }
      format.json { head :no_content }
    end
  end
end
