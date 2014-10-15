class QualityDocumentsController < ApplicationController
before_filter :set_page_info

  def set_page_info
    @menus[:documentation][:active] = "active"
  end

  def index
    @quality_documents = QualityDocument.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @quality_documents = @quality_documents.select{|quality_document|
              quality_document[:id] = quality_document.id
              quality_document[:name] = quality_document.quality_document_name
              quality_document[:links] = CommonActions.object_crud_paths( nil, edit_quality_document_path(quality_document), quality_document_path(quality_document))

          }
          render json: {:aaData => @quality_documents}
       }
    end
  end

  # GET /quality_documents/1
  # GET /quality_documents/1.json
  def show
    @quality_document = QualityDocument.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quality_document }
    end
  end

  # GET /quality_documents/new
  # GET /quality_documents/new.json
  def new
    @quality_document = QualityDocument.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quality_document }
    end
  end

  # GET /quality_documents/1/edit
  def edit
    @quality_document = QualityDocument.find(params[:id])
  end

  # POST /quality_documents
  # POST /quality_documents.json
  def create
    @quality_document = QualityDocument.new(params[:quality_document])

    respond_to do |format|
      if @quality_document.save
        format.html { redirect_to quality_documents_path, notice: 'Quality document was successfully created.' }
        format.json { render json: @quality_document, status: :created, location: @quality_document }
      else
        format.html { render action: "new" }
        format.json { render json: @quality_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quality_documents/1
  # PUT /quality_documents/1.json
  def update
    @quality_document = QualityDocument.find(params[:id])

    respond_to do |format|
      if @quality_document.update_attributes(params[:quality_document])
        format.html { redirect_to quality_documents_path, notice: 'Quality document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quality_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_documents/1
  # DELETE /quality_documents/1.json
  def destroy
    @quality_document = QualityDocument.find(params[:id])
    @quality_document.destroy

    respond_to do |format|
      format.html { redirect_to quality_documents_url }
      format.json { head :no_content }
    end
  end
end
