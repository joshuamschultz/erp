class ItemAltNamesController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  autocomplete :item_alt_name, :item_alt_identifier, :display_value => :alt_item_name
  before_action :user_permissions, only: [:create, :show, :edit]
  before_action :unauthorized

  def unauthorized
    if  user_signed_in? && current_user.is_customer?
      authorize! :edit, ItemAltName
    end
  end

  def user_permissions
    if  user_signed_in? && current_user.is_vendor?
        authorize! :edit, ItemAltName
    end
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  def set_autocomplete_values
    params[:item_alt_name][:organization_id], params[:organization_id] = params[:organization_id], params[:item_alt_name][:organization_id]
    params[:item_alt_name][:organization_id] = params[:org_organization_id] if params[:item_alt_name][:organization_id] == ""

    params[:item_alt_name][:item_id], params[:item_id] = params[:item_id], params[:item_alt_name][:item_id]
    params[:item_alt_name][:item_id] = params[:org_item_id] if params[:item_alt_name][:item_id] == ""
  end

  def get_autocomplete_items(parameters)
    items = active_record_get_autocomplete_items(parameters)
    # matched_altnames = ItemAltName.where("organization_id is NULL or organization_id = ?", params[:organization_id])
    items = ItemAltName.where("item_alt_identifier like ?", "%" + params[:term] + "%")
  end

  # GET /item_alt_names
  # GET /item_alt_names.json
  def index
     # @item_alt_names = ItemAltName.where("organization_id is not NULL")
    @item_alt_names = ItemAltName.get_alt_names(get_all: false)

    respond_to do |format|
      format.html # index.html.erb
      @item_alt_nams = Array.new
      format.json {
        @item_alt_names = @item_alt_names.select{|alt_name|
          alt_nam = Hash.new
          alt_name.attributes.each do |key, value|
            alt_nam[key] = value
          end
          alt_nam[:item_name] = "<a href='#{item_path(alt_name.item)}?item_alt_name_id=#{alt_name.id}&revision_id=#{alt_name.current_revision.id}'> #{alt_name.item.item_part_no} </a>"
          alt_nam[:customer_name] = alt_name.organization.present? ? "<a href='#{organization_path(alt_name.organization)}'> #{alt_name.organization.organization_name} </a>" : ""
          alt_nam[:links] = CommonActions.object_crud_paths( nil, edit_item_alt_name_path(alt_name), nil)
          @item_alt_nams.push(alt_nam)
        }
        render json:  {:aaData => @item_alt_nams}
      }
    end
  end

  # GET /item_alt_names/1
  # GET /item_alt_names/1.json
  def show
    @item_alt_name = ItemAltName.find(params[:id])
    @current_revision = @item_alt_name.current_revision if @item_alt_name.item
    @current_revision = {item_cost: "No Revision Found!"} if @current_revision.nil?
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @current_revision }
    end
  end

  # GET /item_alt_names/new
  # GET /item_alt_names/new.json
  def new
    @item_alt_name = ItemAltName.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_alt_name }
    end
  end

  # GET /item_alt_names/1/edit
  def edit
    @item_alt_name = ItemAltName.find(params[:id])
  end

  # POST /item_alt_names
  # POST /item_alt_names.json
  def create
    @item_alt_name = ItemAltName.new(item_alt_name_params)
    respond_to do |format|
        if params[:new_item] && params[:item_alt_name][:item_id] == "" &&  params[:item_id] != ""
            @item = Item.new(:item_part_no => params[:item_id])
            @item.item_revisions.build
            @item.save(:validate => false)
            @item_alt_name.item_id = @item.id
            @item_alt_name.save
            format.html { redirect_to @item, notice: 'Item was successfully created.' }
        elsif @item_alt_name.save
            format.html { redirect_to item_alt_names_path, notice: 'Alt name was successfully created.' }
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
    @item_alt_name = ItemAltName.find(params[:id])

    respond_to do |format|
      if @item_alt_name.update_attributes(item_alt_name_params)
        format.html { redirect_to item_alt_names_path, notice: 'Alt name was successfully updated.' }
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
    @item_alt_name = ItemAltName.find(params[:id])
    @item_alt_name.destroy

    respond_to do |format|
      format.html { redirect_to item_alt_names_path, notice: 'Alt name was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  private

      def set_item_alt_name
        @item_alt_name = ItemAltName.find(params[:id])
      end

      def item_alt_name_params
        params.require(:item_alt_name).permit(:item_alt_active, :item_alt_created_id, :item_alt_description,
                                              :item_alt_identifier, :item_alt_notes, :item_alt_updated_id, :item_id, :organization_id, :item_revision_id)
      end
end
