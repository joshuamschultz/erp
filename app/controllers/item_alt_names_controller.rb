class ItemAltNamesController < ApplicationController
  # GET /item_alt_names
  # GET /item_alt_names.json
  def index
    @item = Item.find(params[:item_id])
    @item_alt_names = @item.item_alt_names.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { @item_alt_names = @item_alt_names.select{|item_alt_name|
        item_alt_name[:item_name] = item_alt_name.item.item_name
        item_alt_name[:show] = "<a href='/items/#{@item.id}/item_alt_names/#{item_alt_name.id}'> #{item_alt_name.item_alt_identifier} </a>"
        item_alt_name[:links] = CommonActions.object_crud_paths( nil,
                          edit_item_item_alt_name_path(@item,item_alt_name),nil)
      }
        render json:  {:aaData => @item_alt_names} 
      }
    end
  end

  # GET /item_alt_names/1
  # GET /item_alt_names/1.json
  def show
    @item = Item.find(params[:item_id])
    @item_alt_name = @item.item_alt_names.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_alt_name }
    end
  end

  # GET /item_alt_names/new
  # GET /item_alt_names/new.json
  def new
    @item = Item.find(params[:item_id])
    @item_alt_name = @item.item_alt_names.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_alt_name }
    end
  end

  # GET /item_alt_names/1/edit
  def edit
    @item = Item.find(params[:item_id])
    @item_alt_name = @item.item_alt_names.find(params[:id])
  end

  # POST /item_alt_names
  # POST /item_alt_names.json
  def create
    @item = Item.find(params[:item_id])
    @item_alt_name = @item.item_alt_names.new(params[:item_alt_name])
    respond_to do |format|
      if @item_alt_name.save
        format.html { redirect_to item_item_alt_names_path(@item), notice: 'Item alt name was successfully created.' }
        format.json { render json: @item_alt_name, status: :created, location: @item_alt_name }
      else
        format.html { render action: "new" }
        format.json { render json: @item_alt_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_alt_names/1
  # PUT /item_alt_names/1.json
  def update
    @item = Item.find(params[:item_id])
    @item_alt_name = @item.item_alt_names.find(params[:id])

    respond_to do |format|
      if @item_alt_name.update_attributes(params[:item_alt_name])
        format.html { redirect_to item_item_alt_names_path(@item), notice: 'Item alt name was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_alt_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_alt_names/1
  # DELETE /item_alt_names/1.json
  def destroy
    @item = Item.find(params[:item_id])
    @item_alt_name = @item.item_alt_names.find(params[:id])
    @item_alt_name.destroy

    respond_to do |format|
      format.html { redirect_to item_item_alt_names_path(@item), notice: 'Item alt name was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
