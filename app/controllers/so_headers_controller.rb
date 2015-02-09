class SoHeadersController < ApplicationController
  before_filter :find_relations, only: [:index]
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update] 
  # before_filter :check_permissions, :only => [:edit, :destroy]
  autocomplete :so_header, :so_identifier, :full => true

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
    unless  user_signed_in? && current_user.is_vendor? 
      @menus[:sales][:active] = "active"
    end
  end

  def set_autocomplete_values
      params[:so_header][:organization_id], params[:organization_id] = params[:organization_id], params[:so_header][:organization_id]
      params[:so_header][:organization_id] = params[:org_organization_id] if params[:so_header][:organization_id] == ""
  end

  # def check_permissions
  #       authorize! :edit, SoHeader
  # end
  def get_autocomplete_items(parameters)
      items = super(parameters)
      if params[:organization_id].present?
          items = items.where(:organization_id => params[:organization_id])
      end
      items
  end

  def find_relations
      params[:so_status] ||= nil

      if params[:organization_id].present?
          @organization = Organization.find(params[:organization_id])
          @so_headers = @organization.present? ? @organization.sales_orders : []
      elsif params[:item_revision_id].present?
          @item_revision = ItemRevision.find(params[:item_revision_id])
          @so_headers = @item_revision.present? ? @item_revision.sales_orders : []
      elsif params[:item_id].present?
          @item = Item.find(params[:item_id])
          @so_headers = @item.present? ? @item.sales_orders : []
      else
          @so_headers = SoHeader.order("created_at desc")
      end

      @so_headers = @so_headers.status_based_sos(params[:so_status]) if params[:so_status].present? && @so_headers.any?
  end

  def index
    if  @so_headers.find_by_so_identifier("Unassigned").present?
      @so_headers.find_by_so_identifier("Unassigned").delete
      redirect_to action: "index"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json {     
          i = 0    
          @so_headers = @so_headers.select{|so_header|          
            so_header[:index] = i
            so_header[:so_id] = CommonActions.linkable(so_header_path(so_header), so_header.so_identifier)
            so_header[:customer_name] = CommonActions.linkable(organization_path(so_header.organization), so_header.organization.organization_name)
            so_header[:so_line_price] = so_header.so_lines.find_by_item_id(@item.id).so_line_sell if params[:item_id].present?
            so_header[:so_type_qty] =  so_header.so_lines.find_by_item_id(@item.id).so_line_quantity if params[:item_id].present?

            if so_header.bill_to_address
                so_header[:bill_to_address_name] = CommonActions.linkable(contact_path(so_header.bill_to_address), so_header.bill_to_address.contact_description)
            else
                so_header[:bill_to_address_name] = CommonActions.linkable(organization_main_address_path(so_header.organization), so_header.organization.organization_name)
            end
            if so_header.ship_to_address
                so_header[:ship_to_address_name] = CommonActions.linkable(contact_path(so_header.ship_to_address), so_header.ship_to_address.contact_description)
            else
                so_header[:ship_to_address_name] = CommonActions.linkable(organization_main_address_path(so_header.organization), so_header.organization.organization_name)
            end
            if can? :edit, so_header

              so_header[:links] =  CommonActions.object_crud_paths(nil, edit_so_header_path(so_header), nil) 
            
            else
              so_header[:links]=""
            end

             i += 1
           }
           render json: {:aaData => @so_headers} 
        }
      end
    end
  end

  # GET /so_headers/1
  # GET /so_headers/1.json
  def show
    @so_header = SoHeader.find(params[:id])
    if @so_header.so_identifier == "Unassigned"
      @so_header.delete
      redirect_to action: "index"
    else
      @attachable = @so_header
      @notes = @so_header.present? ? @so_header.comments.where(:comment_type => "note").order("created_at desc") : []  
      @attachment = @so_header.attachments.new
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @so_header }
      end
    end
  end

  # GET /so_headers/new
  # GET /so_headers/new.json
  def new
    @so_header = SoHeader.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @so_header }
    end
  end

  # GET /so_headers/1/edit
  def edit
    @so_header = SoHeader.find(params[:id])
  end

  # POST /so_headers
  # POST /so_headers.json
  def create
    @so_header = SoHeader.new(params[:so_header])

    respond_to do |format|
      if @so_header.save        
        format.html { redirect_to new_so_header_so_line_path(@so_header), notice: 'So header was successfully created.' }
        format.json { render json: @so_header, status: :created, location: @so_header }
      else
        format.html { render action: "new" }
        format.json { render json: @so_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /so_headers/1
  # PUT /so_headers/1.json
  def update
    @so_header = SoHeader.find(params[:id])

    respond_to do |format|
      if @so_header.update_attributes(params[:so_header])        
        format.html { redirect_to new_so_header_so_line_path(@so_header), notice: 'So header was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @so_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /so_headers/1
  # DELETE /so_headers/1.json
  def destroy
    @so_header = SoHeader.find(params[:id])
    @so_header.destroy

    respond_to do |format|
      format.html { redirect_to so_headers_url }
      format.json { head :no_content }
    end
  end

  def populate
      @so_header = SoHeader.find(params[:id])

      if params[:type] == "note" && params[:comment].present?
          Comment.process_comments(current_user, @so_header, [params[:comment]], params[:type])
          note = @so_header.comments.where(:comment_type => "note").order("created_at desc").first if @so_header
          note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
          note["created_user"] = note.created_by.name
          note["status"] = "success"
      else
          note = Hash.new
          note["status"] = "fail"
      end

      render json: {:result => note}
  end

  def so_info
      @so_header = SoHeader.find(params[:id])
      @organization = @so_header.organization if @so_header
      if @organization
          render :layout => false
      else
          render :text => "" and return
      end
  end

  def report
      @so_header = SoHeader.find(params[:id])
      render :layout => false
  end

  def packing_report
      @so_header = SoHeader.find(params[:id])
      @company_info = CompanyInfo.first
      render :layout => false

  end


private

  def genarate_pdf 
      p @so_header
      html = render_to_string(:layout => false , :partial => 'so_headers/sales_report')
      kit = PDFKit.new(html, :page_size => 'A4')    
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
  end

end
