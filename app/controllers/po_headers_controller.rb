class PoHeadersController < ApplicationController
  before_action :find_relations, only: [:index]
  before_action :set_page_info
  before_action :set_po_header, only: %i[show edit update destroy]
  before_action :set_autocomplete_values, only: [:create, :update]

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions

  autocomplete :po_header, :po_identifier, :full => true

  def index
    if params[:po_status]
      @po_headers = PoHeader.status_based_pos(params[:po_status])
    else
      @po_headers = PoHeader.all
    end
    # TODO can move this to an automated nightly job via sidekiq?
    # TODO technically many can be created, but if nonoe goes to index.. they will remain and throw off the count
    PoHeader.find_by_po_identifier("Unassigned").delete if @po_headers.find_by_po_identifier("Unassigned").present?
  end

  def show
    @attachable = @po_header
    @notes = @po_header.present? ? @po_header.comments.where(:comment_type => "note").order("created_at desc") : []
  end

  def new
    @po_header = PoHeader.new
  end

  def edit
    if @po_header.po_status == "closed"
      flash[:notice] = 'You can\'t edit, this PO is closed'
      redirect_to action: "index"
    end
  end

  def create
    @po_header = PoHeader.new(po_header_params)
    if @po_header.save
      redirect_to new_po_header_po_line_path(@po_header.id)
    else
      flash[:notice] = 'Customer PO cannot be blank.'
      redirect_to action: "new"
    end
  end

  def update
    @po_header.update_attributes(po_header_params)
    respond_with @po_header
  end

  def destroy
    @po_header.so_header.destroy if @po_header.destroy && @po_header.so_header
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
