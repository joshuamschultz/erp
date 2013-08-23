class SoHeadersController < ApplicationController
  before_filter :find_relations, only: [:index]
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update] 

  def set_page_info
      @menus[:sales][:active] = "active"
  end

  def set_autocomplete_values
      params[:so_header][:organization_id], params[:organization_id] = params[:organization_id], params[:so_header][:organization_id]
      params[:so_header][:organization_id] = params[:org_organization_id] if params[:so_header][:organization_id] == ""
  end

  def find_relations
      params[:so_status] ||= nil

      if params[:organization_id].present?
          @organization = Organization.find(params[:organization_id])
          @so_headers = @organization.present? ? @organization.sales_orders : []
      elsif params[:item_revision_id].present?
          @item_revision = ItemRevision.find(params[:item_revision_id])
          @so_headers = @item_revision.present? ? @item_revision.sales_orders : []
      else
          @so_headers = SoHeader.order(:created_at)
      end

      @so_headers = @so_headers.status_based_sos(params[:so_status]) if params[:so_status].present? && @so_headers.any?
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json {         
        @so_headers = @so_headers.select{|so_header|
          so_header[:so_id] = CommonActions.linkable(so_header_path(so_header), so_header.so_identifier)
          so_header[:customer_name] = CommonActions.linkable(organization_path(so_header.organization), so_header.organization.organization_name)
          so_header[:bill_to_address_name] = CommonActions.linkable(contact_path(so_header.bill_to_address), so_header.bill_to_address.contact_title)
          so_header[:ship_to_address_name] = CommonActions.linkable(contact_path(so_header.ship_to_address), so_header.ship_to_address.contact_title)
          so_header[:links] = CommonActions.object_crud_paths(nil, edit_so_header_path(so_header), nil)
         }
         render json: {:aaData => @so_headers} 
      }
    end
  end

  # GET /so_headers/1
  # GET /so_headers/1.json
  def show
    @so_header = SoHeader.find(params[:id])
    @attachable = @so_header
    @notes = @so_header.present? ? @so_header.comments.where(:comment_type => "note").order("created_at desc") : []  
    @attachment = @so_header.attachments.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @so_header }
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

      if params[:type] == "note"
          Comment.process_comments(current_user, @so_header, [params[:comment]], params[:type])
      end

      redirect_to @so_header
  end

end
