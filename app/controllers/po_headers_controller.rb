class PoHeadersController < ApplicationController
  before_filter :find_relations
  before_filter :set_page_info

  def set_page_info
      @menus[:purchases][:active] = "active"
  end

  def find_relations
      params[:status] ||= "open"

      puts params[:status]

      if params[:vendor_id].present?
          @vendor = Organization.find(params[:vendor_id])
          @po_headers = @vendor.present? ? @vendor.po_headers.where(:po_status => params[:status]).order(:created_at) : []
      else
          @po_headers = PoHeader.where(:po_status => params[:status]).order(:created_at)
      end
  end

  # GET /po_headers
  # GET /po_headers.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @po_headers = @po_headers.select{|po_header|
              po_header[:po_type_name] = po_header.po_type.type_name
              po_header[:vendor_name] = "<a href='#{organization_path(po_header.organization)}'>Vendor : #{po_header.organization.organization_name}</a>"
              po_header[:links] = CommonActions.object_crud_paths(po_header_path(po_header), edit_po_header_path(po_header), nil)
          }
          render json: {:aaData => @po_headers}
      }
    end
  end

  # GET /po_headers/1
  # GET /po_headers/1.json
  def show
    @po_header = PoHeader.find(params[:id])
    @attachable = @po_header
    @notes = @po_header.present? ? @po_header.comments.where(:comment_type => "note").order("created_at desc") : []  

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @po_header }
    end
  end

  # GET /po_headers/new
  # GET /po_headers/new.json
  def new
    @po_header = @po_headers.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @po_header }
    end
  end

  # GET /po_headers/1/edit
  def edit
    @po_header = PoHeader.find(params[:id])
  end

  # POST /po_headers
  # POST /po_headers.json
  def create
    @po_header = PoHeader.new(params[:po_header])

    respond_to do |format|
      if @po_header.save
        format.html { redirect_to @po_header, notice: 'Po header was successfully created.' }
        format.json { render json: @po_header, status: :created, location: @po_header }
      else
        format.html { render action: "new" }
        format.json { render json: @po_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /po_headers/1
  # PUT /po_headers/1.json
  def update
    @po_header = PoHeader.find(params[:id])

    respond_to do |format|
      if @po_header.update_attributes(params[:po_header])
        format.html { redirect_to @po_header, notice: 'Po header was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @po_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /po_headers/1
  # DELETE /po_headers/1.json
  def destroy
    @po_header = PoHeader.find(params[:id])
    @po_header.destroy

    respond_to do |format|
      format.html { redirect_to po_headers_url }
      format.json { head :no_content }
    end
  end

  def populate
      @po_header = PoHeader.find(params[:id])

      if params[:type] == "note"
          Comment.process_comments(current_user, @po_header, [params[:comment]], params[:type])
      end

      redirect_to @po_header
  end


end
