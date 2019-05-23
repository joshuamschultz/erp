class SoLinesController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  before_action :set_so_line, only: %i[show edit update destroy]

  def set_page_info
    @menus[:sales][:active] = "active"
    simple_form_validation = true
    p simple_form_validation
  end

  def auto_complete
    if params[:organization_id].present? && params[:alt_name_id]
      item_id = ItemAltName.find(params[:alt_name_id]).item.id
      complete = PoHeader.joins(:po_lines).where("po_headers.organization_id = ? AND po_lines.item_id = ? AND po_headers.po_identifier LIKE ?", params[:organization_id], item_id, "%#{params[:term]}%")
      render json: complete.map { |product| { :id => product.id, :label => product.po_identifier, :value => product.po_identifier } }
    end
  end

  def set_autocomplete_values
    params[:so_line][:organization_id], params[:organization_id] = params[:organization_id], params[:so_line][:organization_id]
    params[:so_line][:organization_id] = params[:org_organization_id] if params[:so_line][:organization_id] == ""

    params[:so_line][:item_alt_name_id], params[:alt_name_id] = params[:alt_name_id], params[:so_line][:item_alt_name_id]
    params[:so_line][:item_alt_name_id] = params[:org_alt_name_id] if params[:so_line][:item_alt_name_id] == ""

    params[:so_line][:po_header_id], params[:po_header_id] = params[:po_header_id], params[:so_line][:po_header_id]
    params[:so_line][:po_header_id] = params[:org_po_header_id] if params[:so_line][:po_header_id] == ""
  end

  def index
    @so_header = SoHeader.find(params[:so_header_id])
    @so_lines = @so_header.so_lines
  end

  def show
  end

  def new
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.build
  end

  def edit
  end

  def create
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.build(so_line_params)

    respond_to do |format|
      if @so_line.save
        format.html { redirect_to new_so_header_so_line_path(@so_header), :notice => "So line was successfully created." }
        format.json { render :json => @so_line, :status => :created, :location => [@so_line.so_header, @so_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @so_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @so_line.update_attributes(so_line_params)
        format.html { redirect_to(new_so_header_so_line_path(@so_header), :notice => "So line was successfully updated.") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @so_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @so_line.destroy
  end

  private

  def set_so_line
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.find(params[:id])
  end

  def so_line_params
    params.require(:so_line).permit(:so_line_cost, :so_line_created_id, :so_line_freight, :so_line_price, :so_line_quantity,
                                    :so_line_status, :so_line_updated_id, :organization_id, :item_id, :so_header_id, :item_alt_name_id,
                                    :so_line_notes, :so_line_active, :vendor_quality_id, :customer_quality_id, :so_line_shipped, :so_line_sell,
                                    :so_line_vendor_po, :po_header_id, :po, :item_revision_id)
  end

  def genarate_pdf
    html = render_to_string(:layout => false, :partial => "so_headers/sales_report")
    kit = PDFKit.new(html, :page_size => "letter")
    # Get an inline PDF
    pdf = kit.to_pdf
    p pdf
    # Save the PDF to a file
    path = Rails.root.to_s + "/public/sales_report"
    if File.directory? path
      path = path + "/" + @so_header.so_identifier.to_s + ".pdf"
      kit.to_file(path)
    else
      Dir.mkdir path
      path = path + "/" + @so_header.so_identifier.to_s + ".pdf"
      kit.to_file(path)
    end

    html1 = render_to_string(:layout => false, :partial => "so_headers/sales_report")
    kit1 = PDFKit.new(html1, :page_size => "letter")
    # Get an inline PDF
    pdf1 = kit1.to_pdf
    p pdf1
    # Save the PDF to a file
    path1 = Rails.root.to_s + "/public/sales_report"
    if File.directory? path1
      path1 = path1 + "/" + @so_header.so_identifier.to_s + ".pdf"
      kit1.to_file(path1)
    else
      Dir.mkdir path1
      path1 = path1 + "/" + @so_header.so_identifier.to_s + ".pdf"
      kit1.to_file(path1)
    end
  end
end
