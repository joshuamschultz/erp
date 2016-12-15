class PoHeadersController < ApplicationController
  before_action :find_relations, only: [:index]
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  autocomplete :po_header, :po_identifier, :full => true

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_logistics? || current_user.is_quality?  || current_user.is_vendor? )
        authorize! :edit, PoHeader
    end
  end

  def user_permissions
    if  user_signed_in? && current_user.is_customer?
        authorize! :edit, PoHeader
    end
  end

  def set_page_info
    unless  user_signed_in? && current_user.is_customer?
      @menus[:purchases][:active] = "active"
    end
  end

  def set_autocomplete_values
      params[:po_header][:organization_id], params[:organization_id] = params[:organization_id], params[:po_header][:organization_id]
      params[:po_header][:organization_id] = params[:org_organization_id] if params[:po_header][:organization_id] == ""

      params[:po_header][:customer_id], params[:customer_id] = params[:customer_id], params[:po_header][:customer_id]
      params[:po_header][:customer_id] = params[:org_customer_id] if params[:po_header][:customer_id] == ""
  end

  def get_autocomplete_items(parameters)
      items = active_record_get_autocomplete_items(parameters)
      if params[:organization_id].present?
          items = items.where(:organization_id => params[:organization_id])
      end
      items
  end

  def find_relations
      params[:po_status] ||= nil

      if params[:organization_id].present?
          @organization = Organization.find(params[:organization_id])
          @po_headers = @organization.present? ? @organization.purchase_orders.order("created_at desc")  : []
      elsif params[:item_revision_id].present?
          @item_revision = ItemRevision.find(params[:item_revision_id])
          @po_headers = @item_revision.present? ? @item_revision.purchase_orders.order("created_at desc")  : []
      elsif params[:item_id].present?
          @item = Item.find(params[:item_id])
          @po_headers = @item.present? ? @item.purchase_orders.order("created_at desc")  : []
      else
          @po_headers = PoHeader.order("created_at desc")
      end

      @po_headers = @po_headers.status_based_pos(params[:po_status]).order("created_at desc")  if params[:po_status].present? && @po_headers.any?

  end

  # GET /po_headers
  # GET /po_headers.json
  def index
    if  @po_headers.find_by_po_identifier("Unassigned").present?
      @po_headers.find_by_po_identifier("Unassigned").delete
      redirect_to action: "index"
    else
      respond_to do |format|
        @po_heders = Array.new
        format.html # index.html.erb
        format.json {
            i = 0

            if  user_signed_in? && current_user.is_vendor?
              organization_ids = current_user.organizations.collect(&:id)
  #            organization_ids = current_user.organizations.where("organization_type_id =? ", MasterType.find_by_type_value('vendor').id).collect(&:id) To uncomment for Sprint 7
              @po_headers =  @po_headers.reject {|entry| !organization_ids.include? entry[:organization_id]}
            end
            po_line_ids = []
            @po_headers = @po_headers.select{|po_header|
                po_heder = Hash.new
                po_header.attributes.each do |key, value|
                  po_heder[key] = value
                end
                po_heder[:index] = i
                po_heder[:po_id] = CommonActions.linkable(po_header_path(po_header), po_header.po_identifier)
                po_heder[:po_type_name] = po_header.po_type.type_name
                po_heder[:vendor_name] = CommonActions.linkable(organization_path(po_header.organization), po_header.organization.organization_name)
                if can? :edit, PoHeader
                  po_heder[:links] = CommonActions.object_crud_paths(nil, edit_po_header_path(po_header), nil)
                else
                  po_heder[:links] = nil
                end
                if params[:item_id].present?
                  po_lines = PoLine.where(:po_header_id => po_header.id, :item_id => params[:item_id])
                  if po_line_ids != nil?
                    po_lines =  po_lines.reject {|entry| po_line_ids.include? entry[:id]}
                  end
                  po_line_ids<< po_lines.first.id
                  po_heder[:po_line_price] = po_lines.first.po_line_cost.to_f
                  po_heder[:po_type_qty] = po_lines.first.po_line_quantity
                end
                 @po_heders.push(po_heder)
                i += 1
            }
            render json: {:aaData => @po_heders}
        }
      end
    end
  end

  # GET /po_headers/1
  # GET /po_headers/1.json
  def show
     @po_header = PoHeader.find(params[:id])
      if @po_header.po_identifier == "Unassigned"
        @po_header.delete
        redirect_to action: "index"
      else

        @attachable = @po_header
        @notes = @po_header.present? ? @po_header.comments.where(:comment_type => "note").order("created_at desc") : []
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @po_header }
        end
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
    if @po_header.po_status == "closed"
      redirect_to action: "index"
    end
  end

  # POST /po_headers
  # POST /po_headers.json
  def create
    @po_header = PoHeader.new(po_header_params)

    respond_to do |format|
      if @po_header.save

        format.html { redirect_to  new_po_header_po_line_path(@po_header), notice: 'Po header was successfully created.' }
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
      if @po_header.update_attributes(po_header_params)

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

      if params[:type] == "note" && params[:comment].present?
          Comment.process_comments(current_user, @po_header, [params[:comment]], params[:type])
          note = @po_header.comments.where(:comment_type => "note").order("created_at desc").first if @po_header
          note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
          note["created_user"] = note.created_by.name
          note["status"] = "success"
      else
          note = Hash.new
          note["status"] = "fail"
      end

      render json: {:result => note}
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

  def purchase_report
      @po_header = PoHeader.find(params[:id])
      @company_info = CompanyInfo.first
      render :layout => false
  end
  private

    def set_po_header
      @po_header = PoHeader.find(params[:id])
    end

    def po_header_params
      params.require(:po_header).permit(:po_active, :po_created_id, :po_description, :po_identifier, :po_notes,
                                        :po_status, :po_total, :po_type_id, :po_updated_id, :organization_id, :customer_id,
                                        :po_bill_to_id, :po_ship_to_id, :cusotmer_po, :so_header_id)
    end

end
