class QualityLotsController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]  

  def set_page_info
      @menus[:quality][:active] = "active"
  end

  def set_autocomplete_values
      params[:quality_lot][:po_header_id], params[:po_header_id] = params[:po_header_id], params[:quality_lot][:po_header_id]
      params[:quality_lot][:po_header_id] = params[:org_po_header_id] if params[:quality_lot][:po_header_id] == ""

      params[:quality_lot][:process_flow_id], params[:process_flow_id] = params[:process_flow_id], params[:quality_lot][:process_flow_id]
      params[:quality_lot][:process_flow_id] = params[:org_process_flow_id] if params[:quality_lot][:process_flow_id] == ""

      params[:quality_lot][:fmea_type_id], params[:fmea_type_id] = params[:fmea_type_id], params[:quality_lot][:fmea_type_id]
      params[:quality_lot][:fmea_type_id] = params[:org_fmea_type_id] if params[:quality_lot][:fmea_type_id] == ""

      params[:quality_lot][:control_plan_id], params[:control_plan_id] = params[:control_plan_id], params[:quality_lot][:control_plan_id]
      params[:quality_lot][:control_plan_id] = params[:org_control_plan_id] if params[:quality_lot][:control_plan_id] == ""
  end

  def lot_info

  end

  # GET po_headers/1/quality_lots
  # GET po_headers/1/quality_lots.json
  def index
    if params[:item_id].present?
        @item = Item.find(params[:item_id])
        @quality_lots = @item.quality_lots
    else
        @quality_lots = QualityLot.all
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @quality_lots = @quality_lots.select{|quality_lot| 
            quality_lot[:links] = CommonActions.object_crud_paths(nil, edit_quality_lot_path(quality_lot), nil)
            
            quality_lot[:lot_control_no] = CommonActions.linkable(quality_lot_path(quality_lot), quality_lot.lot_control_no)
            # quality_lot[:item_part_no] = CommonActions.linkable(item_path(quality_lot.po_line.item), quality_lot.po_line.item_alt_name.item_alt_identifier)
            
            # quality_lot[:item_with_revision] = CommonActions.linkable(item_path(quality_lot.item_revision.item, 
            # revision_id: quality_lot.item_revision_id), quality_lot.po_line.item_alt_name.item_alt_identifier + 
            # " (Revision: #{quality_lot.item_revision.item_revision_name})")

            quality_lot[:item_part_no] = CommonActions.linkable(item_path(quality_lot.item_revision.item, 
            revision_id: quality_lot.item_revision_id), quality_lot.po_line.item_alt_name.item_alt_identifier)

            quality_lot[:item_revision_name] = CommonActions.linkable(item_path(quality_lot.item_revision.item, 
            revision_id: quality_lot.item_revision_id), quality_lot.item_revision.item_revision_name)

            quality_lot[:po_identifier] = CommonActions.linkable(po_header_path(quality_lot.po_header), quality_lot.po_header.po_identifier)
            
            quality_lot[:inspection_level_name] = quality_lot.inspection_level.type_name if quality_lot.inspection_level
            quality_lot[:inspection_method_name] = quality_lot.inspection_method.type_name if quality_lot.inspection_method
            quality_lot[:inspection_type_name] = quality_lot.inspection_type.type_name if quality_lot.inspection_type
            quality_lot[:inspector_name] = quality_lot.lot_inspector.name if quality_lot.lot_inspector
            quality_lot[:created_date] = quality_lot.created_at.strftime("%b %d, %y")
            quality_lot[:total_lots] = quality_lot.po_line.quality_lots.count
          }
          render json: {:aaData => @quality_lots}
      }
    end
  end

  # GET po_headers/1/quality_lots/1
  # GET po_headers/1/quality_lots/1.json
  def show
    @quality_lot = QualityLot.find(params[:id])
    @po_header = @quality_lot.po_header
    @notes = @quality_lot.present? ? @quality_lot.comments.where(:comment_type => "note").order("created_at desc") : [] 
    @attachable = @quality_lot

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quality_lot }
    end
  end

  # GET po_headers/1/quality_lots/new
  # GET po_headers/1/quality_lots/new.json
  def new
    @quality_lot = QualityLot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quality_lot }
    end
  end

  # GET po_headers/1/quality_lots/1/edit
  def edit
     @quality_lot = QualityLot.find(params[:id])
  end

  # POST po_headers/1/quality_lots
  # POST po_headers/1/quality_lots.json
  def create
    @quality_lot = QualityLot.new(params[:quality_lot])
    @quality_lot.lot_inspector = current_user

    respond_to do |format|
      if @quality_lot.save
        format.html { redirect_to(@quality_lot, :notice => 'Quality lot was successfully created.') }
        format.json { render :json => @quality_lot, :status => :created }
      else
        format.html { render :action => "new" }
        format.json { render :json => @quality_lot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT po_headers/1/quality_lots/1
  # PUT po_headers/1/quality_lots/1.json
  def update
    @quality_lot = QualityLot.find(params[:id])

    respond_to do |format|
      if params[:lot_shelf]
        @quality_lot.lot_shelf_number = params[:quality_lot][:lot_shelf_number]
        @quality_lot.lot_shelf_unit = params[:quality_lot][:lot_shelf_unit]
        @quality_lot.save(:validate => false)
        format.html { redirect_to(@quality_lot, :notice => 'Quality lot was successfully updated.') }
        format.json { head :ok }

      elsif params[:lot_material]
        @quality_lot.quality_lot_materials_attributes = params[:quality_lot][:quality_lot_materials_attributes]
        @quality_lot.save(:validate => false)
        format.html { redirect_to(quality_lot_materials_path(quality_lot_id: @quality_lot.id), :notice => 'Material element test was successfully updated.') }
        format.json { head :ok }

      elsif @quality_lot.update_attributes(params[:quality_lot])
        format.html { redirect_to(@quality_lot, :notice => 'Quality lot was successfully updated.') }
        format.json { head :ok }

      else
        format.html { render :action => "edit" }
        format.json { render :json => @quality_lot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE po_headers/1/quality_lots/1
  # DELETE po_headers/1/quality_lots/1.json
  def destroy
    @quality_lot = QualityLot.find(params[:id])
    @quality_lot.destroy

    respond_to do |format|
      format.html { redirect_to quality_lots_path }
      format.json { head :ok }
    end
  end

  def populate
      @quality_lot = QualityLot.find(params[:id])

      if params[:type] == "note"
          Comment.process_comments(current_user, @quality_lot, [params[:comment]], params[:type])
      end

      redirect_to(@quality_lot, :notice => 'Comment added successfully.')
  end

end
