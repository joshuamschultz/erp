class PoLinesController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  before_action :set_po_line, only: %i[show edit update destroy]

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_logistics? || current_user.is_quality?  || current_user.is_vendor? )
      authorize! :edit, PoLine
    end
  end

  def user_permissions
    if  user_signed_in? && current_user.is_customer?
      authorize! :edit, PoLine
    end
  end

  def set_page_info
      @menus[:purchases][:active] = "active"
      simple_form_validation = true
      p simple_form_validation
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
          @po_lins = Array.new
          @po_lines = @po_lines.select{|po_line|
              po_lin = Hash.new
              po_line.attributes.each do |key, value|
                po_lin[key] = value
              end
              if po_line.po_line_status == "open"
                po_lin[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
              else
                po_lin[:item_part_no] = "<a href='/items/#{po_line.item.id}' style='color: #848482;' >"+po_line.item_alt_name.item_alt_identifier+"</a> "
              end
              po_lin[:item_notes] = po_line.item_revision.present? ? po_line.item_revision.item_notes : ''
              po_lin[:item_transfer_no] = po_line.item_transfer_name.present? ? CommonActions.linkable(item_path(po_line.item_transfer_name.item), po_line.item_transfer_name.item_alt_identifier) : ""
              po_lin[:customer_name] = po_line.organization ? CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) : "CHESS"
              po_lin[:po_line_customer_po] = po_line.po_line_customer_po.present? ? po_line.po_line_customer_po : "Stock"
              if can? :edit , PoLine
                if po_line.po_line_status == "open"
                  po_lin[:links] = CommonActions.object_crud_paths(nil, edit_po_header_po_line_path(@po_header, po_line), nil)
                else
                  po_lin[:links] =  CommonActions.object_crud_paths(nil, nil, nil)
                end
              else
                po_lin[:links] =  CommonActions.object_crud_paths(nil, nil, nil)
              end
              @po_lins.push(po_lin)
          }
          render json: {:aaData => @po_lins}
       }
    end
  end

  # GET po_headers/1/po_lines/1
  # GET po_headers/1/po_lines/1.json
  def show

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

    @po_line.organization = @po_header.customer
    po_lin = Hash.new
    @po_line.attributes.each do |key,value|
      po_lin[key] = value
    end
    po_lin[:organization_org_id] = @po_line.organization_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => po_lin }
    end
  end

  # GET po_headers/1/po_lines/1/edit
  def edit

  end

  # POST po_headers/1/po_lines
  # POST po_headers/1/po_lines.json
  def create
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.build(po_line_params)

    respond_to do |format|
      if @po_line.save
        CommonActions.notification_process("PoLine", @po_line)
        # genarate_pdf
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


    respond_to do |format|
      if @po_line.update_attributes(po_line_params)
        CommonActions.notification_process("PoLine", @po_line)
        # genarate_pdf
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

    @po_line.so_line.destroy if @po_line.destroy && @po_line.so_line

    respond_to do |format|
      format.html { redirect_to new_po_header_po_line_path(@po_header), :notice => 'Line item was successfully deleted.' }
      format.json { head :ok }
    end
  end

private
  def set_po_line
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])
  end

  def po_line_params
    params.require(:po_line).permit(:po_line_active, :po_line_cost, :po_line_created_id, :po_line_customer_po,
                                    :po_line_notes, :po_line_quantity, :po_line_status, :po_line_total, :po_line_updated_id,
                                    :po_header_id, :organization_id, :so_line_id, :vendor_quality_id, :customer_quality_id,
                                    :item_id, :item_revision_id, :item_selected_name_id, :item_alt_name_id, :po_line_shipped,
                                    :alt_name_transfer_id, :po_line_sell, :notification_attributes, :quality_lot_id, :process_type_id)
  end

  def genarate_pdf
      html = render_to_string(:layout => false , :partial => 'po_headers/purchase_report')

      kit = PDFKit.new(html, :page_size => 'A4' )
      # Get an inline PDF
      pdf = kit.to_pdf
      # Save the PDF to a file
      p pdf
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
