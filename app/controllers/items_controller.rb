class ItemsController < ApplicationController
  before_filter :set_page_info
  autocomplete :item, :item_part_no, :full => true
  before_filter :set_autocomplete_values, only: [:create] 

  def set_autocomplete_values
      params[:item][:item_revisions_attributes]["0"][:print_id], params[:print_id] = params[:print_id], params[:item][:item_revisions_attributes]["0"][:print_id]
      params[:item][:item_revisions_attributes]["0"][:material_id], params[:material_id] = params[:material_id], params[:item][:item_revisions_attributes]["0"][:material_id]  
      params[:item][:item_revisions_attributes]["0"][:organization_id], params[:organization_id] = params[:organization_id], params[:item][:item_revisions_attributes]["0"][:organization_id]
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
  end
  
  # GET /items
  # GET /items.json
  def index
    if params[:organization_id].present?
        @organization = Organization.find(params[:organization_id])
        @items = @organization.present? ? @organization.items_with_recent_revision : []
    else
        @items = Item.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @items = @items.select{|item|
            item_revision = item.current_revision
            item[:item_part_no] = "<a href='#{item_path(item)}'><strong>#{item.item_part_no}</strong></a>"            
            if item_revision
              item[:owner_name] = "" #"<strong><a href='#{owner_path(item_revision.owner)}'>#{item_revision.owner.owner_identifier}</a></strong>"              
              item[:item_name] = item_revision.item_name
              item[:item_description] = ""
              item[:vendor_name] = "" # "<a href='#{organization_path(item_revision.organization)}'>#{item_revision.organization.organization_short_name}</a>"
              item[:item_revision_name] = item_revision.item_revision_name
              item[:item_revision_date] = item_revision.item_revision_date
              item[:item_tooling] = item_revision.item_tooling
              item[:item_cost] = item_revision.item_cost
              item[:item_notes] = item_revision.item_notes
              item[:item_alt_parts] = item.customer_alt_names.collect{|alt_name| CommonActions.linkable(item_alt_name_path(alt_name), alt_name.item_alt_identifier) }.join(",  ").html_safe
            else
              item[:owner_name] = ""
              item[:item_name] = ""
              item[:item_description] = ""
              item[:vendor_name] = ""
              item[:item_revision_name] = ""
              item[:item_revision_date] = ""
              item[:item_tooling] = ""
              item[:item_cost] = ""
              item[:item_notes] = ""
              item[:item_alt_parts] = ""
            end
            item[:links] = CommonActions.object_crud_paths( nil, edit_item_path(item), nil)
        }
        render json: {:aaData => @items} 
      }        
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])    
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
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        ItemRevision.process_item_associations(@item.current_revision, params)
        format.html { redirect_to item_path(@item), notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        @item.item_revisions[0].print_id = ""
        @item.item_revisions[0].material_id = ""
        @item.item_revisions[0].organization_id = ""
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
      if @item.update_attributes(params[:item])
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

end