class SoLinesController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]

  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_logistics? || current_user.is_quality?  || current_user.is_customer? )
        authorize! :edit, User
    end 
  end

  def user_permissions
   if  user_signed_in? && current_user.is_vendor? 
        authorize! :edit, User
    end 
  end

  def set_page_info
      @menus[:sales][:active] = "active"
      simple_form_validation = true
  end

  def auto_complete
    if params[:organization_id].present? && params[:alt_name_id]
      item_id = ItemAltName.find(params[:alt_name_id]).item.id
      complete = PoHeader.joins(:po_lines).where("po_headers.organization_id = ? AND po_lines.item_id = ? AND po_headers.po_identifier LIKE ?", params[:organization_id], item_id, "%#{params[:term]}%")
      render json: complete.map { |product| {:id => product.id, :label => product.po_identifier, :value => product.po_identifier} }
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

    respond_to do |format|
      format.html { redirect_to new_so_header_so_line_path(@so_header) }
      format.json { 
        @so_lines = @so_lines.select{|so_line|
          if so_line.so_line_status == "open"
            so_line[:item_part_no] = CommonActions.linkable(item_path(so_line.item), so_line.item_alt_name.item_alt_identifier)
          else
            so_line[:item_part_no] = "<a href='/items/#{so_line.item.id}' style='color: #848482;' >"+so_line.item_alt_name.item_alt_identifier+"</a> "
          end


          so_line[:vendor_name] = so_line.organization ? CommonActions.linkable(organization_path(so_line.organization), so_line.organization.organization_name) : "CHESS"
          so_line[:vendor_po] = so_line.po_header.present? ? CommonActions.linkable(po_header_path(so_line.po_header), so_line.po_header.po_identifier) : "Stock"
          so_line[:quality_level_name] = so_line.customer_quality ? CommonActions.linkable(customer_quality_path(so_line.customer_quality), so_line.customer_quality.quality_name) : ""
          if can? :edit , SoLine
            so_line[:links] = CommonActions.object_crud_paths(nil, edit_so_header_so_line_path(@so_header, so_line), nil)
          else
            so_line[:links] = nil
          end
          so_line[:customer_name] = CommonActions.linkable(organization_path(@so_header.organization), @so_header.organization.organization_name)
        }
        render json: {:aaData => @so_lines} 
      }
    end
  end


  def show
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @so_line }
    end
  end

 
  def new 
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @so_line }
    end
  end

  # GET so_headers/1/so_lines/1/edit
  def edit
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.find(params[:id])
  end

  
  def create
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.build(params[:so_line])

    respond_to do |format|
      if @so_line.save
        format.html { redirect_to new_so_header_so_line_path(@so_header), :notice => 'So line was successfully created.' }
        format.json { render :json => @so_line, :status => :created, :location => [@so_line.so_header, @so_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @so_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT so_headers/1/so_lines/1
  # PUT so_headers/1/so_lines/1.json
  def update
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.find(params[:id])

    respond_to do |format|
      if @so_line.update_attributes(params[:so_line])
        format.html { redirect_to(new_so_header_so_line_path(@so_header), :notice => 'So line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @so_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE so_headers/1/so_lines/1
  # DELETE so_headers/1/so_lines/1.json
  def destroy
    @so_header = SoHeader.find(params[:so_header_id])
    @so_line = @so_header.so_lines.find(params[:id])
    @so_line.destroy

    respond_to do |format|
      format.html { redirect_to so_header_so_lines_url(@so_header) }
      format.json { head :ok }
    end
  end

private

  def genarate_pdf 
      html = render_to_string(:layout => false , :partial => 'so_headers/sales_report')
      kit = PDFKit.new(html, :page_size => 'letter' )  
      # Get an inline PDF
      pdf = kit.to_pdf
      # Save the PDF to a file    
      path = Rails.root.to_s+"/public/sales_report"
      if File.directory? path
        path = path+"/"+@so_header.so_identifier.to_s+".pdf"
        kit.to_file(path)
      else
        Dir.mkdir path
        path = path+"/"+@so_header.so_identifier.to_s+".pdf"
        kit.to_file(path)
      end


      html1 = render_to_string(:layout => false , :partial => 'so_headers/sales_report')
      kit1 = PDFKit.new(html1, :page_size => 'letter' )  
      # Get an inline PDF
      pdf1 = kit1.to_pdf
      # Save the PDF to a file    
      path1 = Rails.root.to_s+"/public/sales_report"
      if File.directory? path1
        path1 = path1+"/"+@so_header.so_identifier.to_s+".pdf"
        kit1.to_file(path1)
      else
        Dir.mkdir path1
        path1 = path1+"/"+@so_header.so_identifier.to_s+".pdf"
        kit1.to_file(path1)
      end
  end

end
