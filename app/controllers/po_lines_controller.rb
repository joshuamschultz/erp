class PoLinesController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]

  def set_page_info
      @menus[:purchases][:active] = "active"
      simple_form_validation = true
  end

  def set_autocomplete_values
    params[:po_line][:organization_id], params[:organization_id] = params[:organization_id], params[:po_line][:organization_id]
    params[:po_line][:organization_id] = params[:org_organization_id] if params[:po_line][:organization_id] == ""

    params[:po_line][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:po_line][:item_alt_name_id]
    params[:po_line][:item_alt_name_id] = params[:org_alt_name_id] if params[:po_line][:item_alt_name_id] == "" || params[:po_line][:item_alt_name_id].nil?

    params[:po_line][:alt_name_transfer_id], params[:item_transfer_name_id] = params[:item_transfer_name_id], params[:po_line][:alt_name_transfer_id]
    params[:po_line][:alt_name_transfer_id] = params[:org_item_transfer_name_id] if params[:po_line][:alt_name_transfer_id] == "" || params[:po_line][:alt_name_transfer_id].nil?
  end
  
  # GET po_headers/1/po_lines
  # GET po_headers/1/po_lines.json
  def index
    @po_header = PoHeader.find(params[:po_header_id])
    @po_lines = @po_header.po_lines

    respond_to do |format|
      format.html { redirect_to new_po_header_po_line_path(@po_header) }
      format.json { 
          @po_lines = @po_lines.select{|po_line|
              po_line[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
              po_line[:item_notes] = po_line.item_revision.item_notes
              po_line[:item_transfer_no] = po_line.item_transfer_name.present? ? CommonActions.linkable(item_path(po_line.item_transfer_name.item), po_line.item_transfer_name.item_alt_identifier) : ""
              po_line[:customer_name] = po_line.organization ? CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) : "CHESS"
              po_line[:po_line_customer_po] = po_line.po_line_customer_po.present? ? po_line.po_line_customer_po : "Stock"              
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
    @po_line.organization = @po_header.customer

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @po_line }
    end
  end

  # GET po_headers/1/po_lines/1/edit
  def edit
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])
  end

  # POST po_headers/1/po_lines
  # POST po_headers/1/po_lines.json
  def create
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.build(params[:po_line])

    respond_to do |format|
      if @po_line.save
        genarate_pdf
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
        genarate_pdf
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
    @po_line.so_line.destroy if @po_line.destroy && @po_line.so_line

    respond_to do |format|
      format.html { redirect_to new_po_header_po_line_path(@po_header), :notice => 'Line item was successfully deleted.' }
      format.json { head :ok }
    end
  end
  
private

  def genarate_pdf 
      html = render_to_string(:layout => false , :partial => 'po_headers/purchase_report')
      p "===================================="
        p html
      p "===================================="

      kit = PDFKit.new(html, :page_size => 'A4' )  
      # Get an inline PDF
      pdf = kit.to_pdf
      # Save the PDF to a file    
      path = Rails.root.to_s+"/public/purchase_report"
      if File.directory? path
        path = path+"/"+@po_header.po_identifier.to_s+".pdf"
        kit.to_file(path)
      else
        Dir.mkdir path
        path = path+"/"+@po_header.po_identifier.to_s+".pdf"
        kit.to_file(path)
      end

  end
end
