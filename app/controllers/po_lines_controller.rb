class PoLinesController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]

  def set_page_info
      @menus[:purchases][:active] = "active"
  end

  def set_autocomplete_values
    params[:po_line][:organization_id], params[:organization_id] = params[:organization_id], params[:po_line][:organization_id]
    params[:po_line][:organization_id] = params[:org_organization_id] if params[:po_line][:organization_id] == ""

    params[:po_line][:item_selected_name_id], params[:alt_name_id] = params[:alt_name_id], params[:po_line][:item_selected_name_id]
    params[:po_line][:item_selected_name_id] = params[:alt_name_id] if params[:po_line][:item_selected_name_id] == ""
  end
  
  # GET po_headers/1/po_lines
  # GET po_headers/1/po_lines.json
  def index
    @po_header = PoHeader.find(params[:po_header_id])
    @po_lines = @po_header.po_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @po_lines = @po_lines.select{|po_line|
              po_line[:item_part_no] = CommonActions.linkable(item_path(po_line.item, revision_id: po_line.item_revision.id), po_line.item.item_part_no)
              po_line[:customer_name] = CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name)
              po_line[:customer_quality_name] = CommonActions.linkable(customer_quality_path(po_line.customer_quality), po_line.customer_quality.quality_name)
              po_line[:links] = CommonActions.object_crud_paths(nil, edit_po_header_po_line_path(@po_header, po_line), nil)
          }
          render json: {:aaData => @po_lines}
       }
    end
  end

  # GET po_headers/1/po_lines/1
  # GET po_headers/1/po_lines/1.json
  def show
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @po_line }
    end
  end

  # GET po_headers/1/po_lines/new
  # GET po_headers/1/po_lines/new.json
  def new
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.build
    @po_line[:organization_org_id] = @po_line.organization_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @po_line }
    end
  end

  # GET po_headers/1/po_lines/1/edit
  def edit
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])
    # @po_line[:organization_org_id] = @po_line.organization_id
  end

  # POST po_headers/1/po_lines
  # POST po_headers/1/po_lines.json
  def create
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.build(params[:po_line])

    respond_to do |format|
      if @po_line.save
        format.html { redirect_to new_po_header_po_line_path(@po_header), :notice => 'Line item was successfully created.' }
        format.json { render :json => @po_line, :status => :created, :location => [@po_line.po_header, @po_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @po_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT po_headers/1/po_lines/1
  # PUT po_headers/1/po_lines/1.json
  def update
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])    

    respond_to do |format|
      if @po_line.update_attributes(params[:po_line])
        format.html { redirect_to new_po_header_po_line_path(@po_header), :notice => 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @po_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE po_headers/1/po_lines/1
  # DELETE po_headers/1/po_lines/1.json
  def destroy
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])
    @po_line.destroy

    respond_to do |format|
      format.html { redirect_to new_po_header_po_line_path(@po_header), :notice => 'Line item was successfully deleted.' }
      format.json { head :ok }
    end
  end
end
