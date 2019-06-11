class ItemsController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create]
  before_action :set_item, only: %i[show edit update destroy]

  autocomplete :item, :item_part_no, :full => true

  def index
    if params[:organization_id].present?
      @organization = Organization.find(params[:organization_id])
      if @organization.type_name == "vendor"
        @items = @organization.present? ? @organization.po_items : []
      elsif @organization.type_name == "customer"
        @items = @organization.present? ? @organization.so_items : []
      elsif @organization.type_name == "support"
        @items =  []
      end
    else
    # NOTE: commented until the scope is fixed.
    # fixed
     @items = Item.item_with_recent_revisions.order('item_part_no asc')
     #@items = Item.all.order('item_part_no asc')
    end
    respond_to do |format|
     format.html # index.html.erb
     format.json {
      if @items.present?
        @po_lines = PoLine.all
        if  user_signed_in? && current_user.is_customer?
          organization_ids = current_user.organizations.where("organization_type_id =? ",5).collect(&:id)
          if organization_ids.present?
            @po_lines =  @po_lines.delete_if {|entry| !organization_ids.include? entry[:organization_id]}
            @po_lines =  @po_lines.collect(&:item_id)
           @items = @items.delete_if {|entry| !@po_lines.include? entry[:id]}
          end
        end
        items_new =Array.new
        @items.each {|item|
          item.item_revisions.each {|item_revision|
            item_with_revision = Hash.new
            if item_revision
              item_with_revision[:item_part_no] = item_revision.present? ? CommonActions.linkable(item_path(item_revision.item,
              revision_id: item_revision.id), item.item_part_no)  : ""
              item_with_revision[:owner_name] = "" #"<strong><a href='#{owner_path(item_revision.owner)}'>#{item_revision.owner.owner_identifier}</a></strong>"
              item_with_revision[:item_name] = item_revision.item_name
              item_with_revision[:item_description] = ""
              item_with_revision[:vendor_name] = ""#"<a href='#{organization_path(item_revision.organization)}'>#{item_revision.organization.organization_short_name}</a>"
              item_with_revision[:item_revision_name] = item_revision.item_revision_name
              item_with_revision[:item_revision_date] = item_revision.item_revision_date
              item_with_revision[:item_tooling] = item_revision.item_tooling
              item_with_revision[:item_cost] = item.weighted_cost
              item_with_revision[:item_notes] = item_revision.item_notes
              item_with_revision[:item_alt_parts] = item.customer_alt_names.collect{|alt_name| CommonActions.linkable(item_alt_name_path(alt_name), alt_name.item_alt_identifier) }.join(",  ").html_safe
              item_with_revision[:item_quantity_in_hand] =  item.stock(ItemRevision.find(item_revision.id))
              item_with_revision[:item_quantity_on_order] = item.qty_on_order(ItemRevision.find(item_revision.id))
              item_with_revision[:item_sell] = item_revision.item_sell.present? ? item_revision.item_sell : 0.0
              item_with_revision[:item_active] = item.item_active
            else
              item_with_revision[:item_part_no] = item_revision.present? ? CommonActions.linkable(item_path(item_revision.item,
              revision_id: item_revision.id), item.item_part_no)  : ""
              item_with_revision[:owner_name] = ""
              item_with_revision[:item_name] = ""
              item_with_revision[:item_description] = ""
              item_with_revision[:vendor_name] = ""
              item_with_revision[:item_revision_name] = ""
              item_with_revision[:item_revision_date] = ""
              item_with_revision[:item_tooling] = ""
              item_with_revision[:item_cost] = ""
              item_with_revision[:item_notes] = ""
              item_with_revision[:item_alt_parts] = ""
              item_with_revision[:item_active] = item.item_active
            end
            item_with_revision[:links] = CommonActions.object_crud_paths( nil, edit_item_path(item), nil)
#
            items_new << item_with_revision
          }
        }
        @items = items_new
      end
      render json: {:aaData => @items}
     }
    end
  end

  def show
    @item_revision = @item.item_revisions.find_by_id(params[:revision_id])
    @item_revision = @item.current_revision unless @item_revision
    @attachable = @item_revision
    @po_lines = PoLine.where(item_revision_id: @item_revision.id)
  end

  def new
    @item = Item.new
    @item.item_revisions.build
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      ItemRevision.process_item_associations(@item.current_revision, params)
      redirect_to items_path
    else
      render :new
    end
  end

  def update
      if @item.update_attributes(item_params)
        ItemRevision.process_item_associations(@item.current_revision, params)
    end
  end

  def destroy
    @item.destroy
  end

  def set_autocomplete_values
    params[:item][:item_revisions_attributes]["0"][:print_id], params[:print_id] = params[:print_id], params[:item][:item_revisions_attributes]["0"][:print_id]
    params[:item][:item_revisions_attributes]["0"][:print_id] = params[:org_print_id] if params[:item][:print_id] == ""
    params[:item][:item_revisions_attributes]["0"][:material_id], params[:material_id] = params[:material_id], params[:item][:item_revisions_attributes]["0"][:material_id]
    params[:item][:item_revisions_attributes]["0"][:material_id] = params[:org_material_id] if params[:item][:material_id] == ""
    # params[:item][:item_revisions_attributes]["0"][:organization_id], params[:organization_id] = params[:organization_id], params[:item][:item_revisions_attributes]["0"][:organization_id]
    # params[:item][:item_revisions_attributes]["0"][:organization_id] = params[:org_organization_id] if params[:item][:organization_id] == ""
  end

  def set_page_info
    @menus[:inventory][:active] = "active"
  end

  private

      def set_item
        @item = Item.find(params[:id])
      end

      def item_params
        params.require(:item).permit(:item_part_no, :item_quantity_in_hand, :item_quantity_on_order, :item_active,
                                      :item_created_id, :item_updated_id, :item_alt_part_no, 
                                      item_revisions_attributes: [:item_cost, :item_description, :item_name, :item_notes, :item_revision_created_id,
                                            :item_revision_date, :item_revision_name, :item_revision_updated_id, :item_tooling, :item_id,
                                            :organization_id, :vendor_quality_id, :customer_quality_id, :print_id, :material_id, :latest_revision,
                                            :item_revision_complete, :item_sell])
      end
end
