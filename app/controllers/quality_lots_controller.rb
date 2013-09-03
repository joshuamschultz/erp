class QualityLotsController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]  

  def set_page_info
      @menus[:quality][:active] = "active"
  end

  def set_autocomplete_values
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
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lots = @po_header.quality_lots

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @quality_lots = @quality_lots.select{|quality_lot| 
            quality_lot[:links] = CommonActions.object_crud_paths(nil, edit_po_header_quality_lot_path(@po_header, quality_lot), nil)
            quality_lot[:lot_control_no] = CommonActions.linkable(po_header_quality_lot_path(@po_header, quality_lot), quality_lot.id)
            quality_lot[:item_part_no] = CommonActions.linkable(item_path(quality_lot.po_line.item), quality_lot.po_line.item_alt_name.item_alt_identifier)
            quality_lot[:item_with_revision] = CommonActions.linkable(item_path(quality_lot.item_revision.item, 
            revision_id: quality_lot.item_revision_id), quality_lot.po_line.item_alt_name.item_alt_identifier + " (Revision: " + 
            quality_lot.item_revision.item_revision_name + ")")
            
            quality_lot[:inspection_level_name] = quality_lot.inspection_level.type_name if quality_lot.inspection_level
            quality_lot[:inspection_method_name] = quality_lot.inspection_method.type_name if quality_lot.inspection_method
            quality_lot[:inspection_type_name] = quality_lot.inspection_type.type_name if quality_lot.inspection_type
            quality_lot[:inspector_name] = quality_lot.lot_inspector.name if quality_lot.lot_inspector
          }
          render json: {:aaData => @quality_lots}
      }
    end
  end

  # GET po_headers/1/quality_lots/1
  # GET po_headers/1/quality_lots/1.json
  def show
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])
    @notes = @quality_lot.present? ? @quality_lot.comments.where(:comment_type => "note").order("created_at desc") : [] 

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quality_lot }
    end
  end

  # GET po_headers/1/quality_lots/new
  # GET po_headers/1/quality_lots/new.json
  def new
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @quality_lot }
    end
  end

  # GET po_headers/1/quality_lots/1/edit
  def edit
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])
  end

  # POST po_headers/1/quality_lots
  # POST po_headers/1/quality_lots.json
  def create
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.build(params[:quality_lot])
    @quality_lot.lot_inspector = current_user

    respond_to do |format|
      if @quality_lot.save
        format.html { redirect_to([@quality_lot.po_header, @quality_lot], :notice => 'Quality lot was successfully created.') }
        format.json { render :json => @quality_lot, :status => :created, :location => [@quality_lot.po_header, @quality_lot] }
      else
        @quality_lot.process_flow_id = ""
        @quality_lot.fmea_type_id = ""
        @quality_lot.control_plan_id = ""
        format.html { render :action => "new" }
        format.json { render :json => @quality_lot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT po_headers/1/quality_lots/1
  # PUT po_headers/1/quality_lots/1.json
  def update
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])

    respond_to do |format|
      if @quality_lot.update_attributes(params[:quality_lot])
        format.html { redirect_to([@quality_lot.po_header, @quality_lot], :notice => 'Quality lot was successfully updated.') }
        format.json { head :ok }
      else
        @quality_lot.process_flow_id = ""
        @quality_lot.fmea_type_id = ""
        @quality_lot.control_plan_id = ""
        format.html { render :action => "edit" }
        format.json { render :json => @quality_lot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE po_headers/1/quality_lots/1
  # DELETE po_headers/1/quality_lots/1.json
  def destroy
    @po_header = PoHeader.find(params[:po_header_id])
    @quality_lot = @po_header.quality_lots.find(params[:id])
    @quality_lot.destroy

    respond_to do |format|
      format.html { redirect_to po_header_quality_lots_url(@po_header) }
      format.json { head :ok }
    end
  end

  def populate
      @po_header = PoHeader.find(params[:po_header_id])
      @quality_lot = @po_header.quality_lots.find(params[:id])

      if params[:type] == "note"
          Comment.process_comments(current_user, @quality_lot, [params[:comment]], params[:type])
      end

      redirect_to([@po_header, @quality_lot], :notice => 'Comment added successfully.')
  end

end
