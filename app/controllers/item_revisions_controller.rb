class ItemRevisionsController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]

  # GET items/1/item_revisions
  # GET items/1/item_revisions.json
  def set_autocomplete_values
      params[:item_revision][:print_id], params[:print_id] = params[:print_id], params[:item_revision][:print_id]
      params[:item_revision][:print_id] = params[:org_print_id] if params[:item_revision][:print_id] == ""

      params[:item_revision][:material_id], params[:material_id] = params[:material_id], params[:item_revision][:material_id]
      params[:item_revision][:material_id] = params[:org_material_id] if params[:item_revision][:material_id] == ""

      # params[:item_revision][:organization_id], params[:organization_id] = params[:organization_id], params[:item_revision][:organization_id]
      # params[:item_revision][:organization_id] = params[:org_organization_id] if params[:item_revision][:organization_id] == ""
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  def index
    @item = Item.find(params[:item_id])
    @item_revisions = @item.item_revisions.order("item_revision_date desc")

    respond_to do |format|
      format.html # index.html.erb
      @item_revsions = Array.new
      format.json {
        @item_revisions = @item_revisions.select{|revision|
            revsion = Hash.new
            revision.attributes.each do |key, value|
              revsion[key] = value
            end
            revsion[:item_revision_name] = "<a href='#{item_path(@item, revision_id: revision.id)}'>#{revision.item_revision_name}</a>"
           if can? :edit, Item
            revsion[:links] = CommonActions.object_crud_paths(nil, edit_item_item_revision_path(@item, revision), nil)
           else
            revsion[:links] = ""
           end
           @item_revsions.push(revsion)
        }
        render json: {:aaData => @item_revsions}
      }
    end
  end

  # GET items/1/item_revisions/1
  # GET items/1/item_revisions/1.json
  def show
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item_revision }
    end
  end

  # GET items/1/item_revisions/new
  # GET items/1/item_revisions/new.json
  def new
    @item = Item.find(params[:item_id])

    # @item_revision = @item.current_revision.present? ? @item.current_revision.dup : @item.item_revisions.build

    if @item.current_revision
        @item_revision = @item.current_revision.dup
        @item_revision.item_processes = @item.current_revision.item_processes
        @item_revision.item_specifications = @item.current_revision.item_specifications
    else
        @item_revision = @item.item_revisions.build
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item_revision }
    end
  end

  # GET items/1/item_revisions/1/edit
  def edit
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:id])
  end

  # POST items/1/item_revisions
  # POST items/1/item_revisions.json
  def create
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.build(item_revision_params)

    respond_to do |format|
      if @item_revision.save
        ItemRevision.process_item_associations(@item_revision, params)
        format.html { redirect_to(@item, :notice => 'Item revision was successfully created.') }
        format.json { render :json => @item_revision, :status => :created, :location => [@item_revision.item, @item_revision] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @item_revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT items/1/item_revisions/1
  # PUT items/1/item_revisions/1.json
  def update
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:id])

    respond_to do |format|
      if @item_revision.update_attributes(item_revision_params)
        ItemRevision.process_item_associations(@item_revision, params)
        format.html { redirect_to(@item, :notice => 'Item revision was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @item_revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE items/1/item_revisions/1
  # DELETE items/1/item_revisions/1.json
  def destroy
    @item = Item.find(params[:item_id])
    @item_revision = @item.item_revisions.find(params[:id])
    @item_revision.destroy

    respond_to do |format|
      if @item.item_revisions.count == 0
        format.html { redirect_to items_path, :notice => 'Item revision was successfully deleted.' }
        format.json { head :ok }
      else
        format.html { redirect_to item_path(@item), :notice => 'Item revision was successfully deleted.' }
        format.json { head :ok }
      end
    end
  end
  private

    def set_item
      @item = Item.find(params[:item_id])
    end

    def item_revision_params
      params.require(:item_revision).permit(:item_cost, :item_description, :item_name, :item_notes, :item_revision_created_id,
                                            :item_revision_date, :item_revision_name, :item_revision_updated_id, :item_tooling, :item_id, :owner_id,
                                            :organization_id, :vendor_quality_id, :customer_quality_id, :print_id, :material_id, :latest_revision,
                                            :item_revision_complete, :item_sell)
    end
end
