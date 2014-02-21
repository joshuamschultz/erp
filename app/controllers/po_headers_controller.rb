class PoHeadersController < ApplicationController
  before_filter :find_relations, only: [:index] 
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]  
  autocomplete :po_header, :po_identifier, :full => true

  def set_page_info
      @menus[:purchases][:active] = "active"
  end

  def set_autocomplete_values
      params[:po_header][:organization_id], params[:organization_id] = params[:organization_id], params[:po_header][:organization_id]
      params[:po_header][:organization_id] = params[:org_organization_id] if params[:po_header][:organization_id] == ""

      params[:po_header][:customer_id], params[:customer_id] = params[:customer_id], params[:po_header][:customer_id]
      params[:po_header][:customer_id] = params[:org_customer_id] if params[:po_header][:customer_id] == ""
  end

  def get_autocomplete_items(parameters)
      items = super(parameters)
      if params[:organization_id].present?
          items = items.where(:organization_id => params[:organization_id])
      end
      items
  end

  def find_relations
      params[:po_status] ||= nil

      if params[:organization_id].present?
          @organization = Organization.find(params[:organization_id])
          @po_headers = @organization.present? ? @organization.purchase_orders : []
      elsif params[:item_revision_id].present?
          @item_revision = ItemRevision.find(params[:item_revision_id])
          @po_headers = @item_revision.present? ? @item_revision.purchase_orders : []
      elsif params[:item_id].present?
          @item = Item.find(params[:item_id])
          @po_headers = @item.present? ? @item.purchase_orders : []
      else
          @po_headers = PoHeader.order(:created_at)
      end

      @po_headers = @po_headers.status_based_pos(params[:po_status]) if params[:po_status].present? && @po_headers.any?
  end

  # GET /po_headers
  # GET /po_headers.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json {           
          @po_headers = @po_headers.select{|po_header|
              po_header[:po_id] = CommonActions.linkable(po_header_path(po_header), po_header.po_identifier)
              po_header[:po_type_name] = po_header.po_type.type_name
              po_header[:vendor_name] = CommonActions.linkable(organization_path(po_header.organization), po_header.organization.organization_name)
              po_header[:links] = CommonActions.object_crud_paths(nil, edit_po_header_path(po_header), nil)
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
    @po_header = PoHeader.new

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
        format.html { redirect_to  edit_po_header_path(@po_header), notice: 'Po header was successfully created.' }
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
        format.html { redirect_to new_po_header_po_line_path(@po_header), notice: 'Po header was successfully updated.' }
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
    @po_header.so_header.destroy if @po_header.destroy && @po_header.so_header

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

  def po_info
      @po_header = PoHeader.find(params[:id])
      @organization = @po_header.organization if @po_header
      if @organization
          render :layout => false
      else
          render :text => "" and return
      end
  end


end
