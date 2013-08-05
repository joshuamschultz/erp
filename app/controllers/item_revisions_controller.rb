class ItemRevisionsController < ApplicationController
  # GET items/1/item_revisions
  # GET items/1/item_revisions.json
  def index
    @item = Item.find(params[:item_id])
    @item_revisions = @item.item_revisions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @item_revisions }
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
    @item_revision = @item.item_revisions.build

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
    @item_revision = @item.item_revisions.build(params[:item_revision])

    respond_to do |format|
      if @item_revision.save
        format.html { redirect_to([@item_revision.item, @item_revision], :notice => 'Item revision was successfully created.') }
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
      if @item_revision.update_attributes(params[:item_revision])
        format.html { redirect_to([@item_revision.item, @item_revision], :notice => 'Item revision was successfully updated.') }
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
      format.html { redirect_to item_item_revisions_url(item) }
      format.json { head :ok }
    end
  end
end
