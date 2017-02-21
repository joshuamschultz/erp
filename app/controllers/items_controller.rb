class ItemsController < ApplicationController
  before_action :set_page_info
  autocomplete :item, :item_part_no, :full => true
  before_action :set_autocomplete_values, only: [:create]

  before_action :view_permissions, except: [:index, :show]

  def view_permissions
    if  user_signed_in? && ( current_user.is_logistics?  || current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, Item
    end
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

  # GET /items
  # GET /items.json
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

         @items = Item.order('item_part_no asc')

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
          @items_new =Array.new
          @items = @items.select{|item|
            @items = item.item_revisions.select{|item_revision|
              item_with_revision = Hash.new
              if item_revision
                item_with_revision[:item_part_no] = item_revision.present? ? CommonActions.linkable(item_path(item_revision.item,
                revision_id: item_revision.id), item.item_part_no)  : ""
                item_with_revision[:owner_name] = "" #"<strong><a href='#{owner_path(item_revision.owner)}'>#{item_revision.owner.owner_identifier}</a></strong>"
                item_with_revision[:item_name] = item_revision.item_name
                item_with_revision[:item_description] = ""
                item_with_revision[:vendor_name] = "" # "<a href='#{organization_path(item_revision.organization)}'>#{item_revision.organization.organization_short_name}</a>"
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

              funct_ebay = 'updateeBay(' + item.id.to_s

              funct_ebay = funct_ebay + ','
              funct_ebay = funct_ebay + item_revision.id.to_s
              funct_ebay = funct_ebay + ');'

              funct_amazon = 'updateAmazon(' + item.id.to_s
              funct_amazon = funct_amazon + ','
              funct_amazon = funct_amazon + item_revision.id.to_s
              funct_amazon = funct_amazon + ');'
              ebay_res_div = ' eBay <div id="ebay_update_info_'+ item_revision.id.to_s
              ebay_res_div = ebay_res_div + '"></div>'
              amazon_res_div = ' Amazon <div id="amazon_update_info_'+ item_revision.id.to_s
              amazon_res_div = amazon_res_div + '"></div>'
              item_with_revision[:item_part_sync] = ItemRevision.item_sync_checkbox(item_revision)
              # item_with_revision[:push_eBay] = CommonActions.check_boxes(item.item_part_no, item_revision.id, funct_ebay) + ebay_res_div
              # item_with_revision[:push_Amazon] = CommonActions.check_boxes(item.item_part_no, item_revision.id,funct_amazon ) + amazon_res_div

              @items_new << item_with_revision
            }
          }
          @items = @items_new
        end
        render json: {:aaData => @items}
      }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @quote_type_item = params[:type] if params[:type]
    if @item
      @item_revision = @item.item_revisions.find_by_id(params[:revision_id])
      @item_revision = @item.current_revision unless @item_revision
      @attachable = @item_revision
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_revision }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
    @item.item_revisions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        ItemRevision.process_item_associations(@item.current_revision, params)
        format.html { redirect_to item_path(@item), notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(item_params)
        # ItemRevision.process_item_associations(@item.current_revision, params)
        format.html { redirect_to item_path(@item), notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_path }
      format.json { head :no_content }
    end
  end
  private

      def set_item
        @item = Item.find(params[:id])
      end

      def item_params
        params.require(:item).permit(:item_part_no, :item_quantity_in_hand, :item_quantity_on_order, :item_active,
                                      :item_created_id, :item_updated_id, :item_alt_part_no, item_revisions_attributes: [:item_cost, :item_description, :item_name, :item_notes, :item_revision_created_id,
                                            :item_revision_date, :item_revision_name, :item_revision_updated_id, :item_tooling, :item_id, :owner_id,
                                            :organization_id, :vendor_quality_id, :customer_quality_id, :print_id, :material_id, :latest_revision,
                                            :item_revision_complete, :item_sell])
      end
end
