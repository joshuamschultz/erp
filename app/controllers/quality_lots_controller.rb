class QualityLotsController < ApplicationController
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  autocomplete :quality_lot, :lot_control_no, :full => true

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_logistics? || current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, QualityLot
    end
  end

  def user_permissions
    if  user_signed_in? && current_user.is_clerical?
      authorize! :edit, QualityLot
    end
  end

  def set_page_info
    unless params[:type].present?
      @menus[:quality][:active] = "active"
    else
      @menus[:reports][:active] = "active"
    end
  end

  def set_autocomplete_values
      params[:quality_lot][:po_header_id], params[:po_header_id] = params[:po_header_id], params[:quality_lot][:po_header_id]
      params[:quality_lot][:po_header_id] = params[:org_po_header_id] if params[:quality_lot][:po_header_id] == ""

    if params[:quality_lot][:process_flow_id].present?
      params[:quality_lot][:process_flow_id], params[:process_flow_id] = params[:process_flow_id], params[:quality_lot][:process_flow_id]
      params[:quality_lot][:process_flow_id] = params[:org_process_flow_id] if params[:quality_lot][:process_flow_id] == ""
    end

    if params[:quality_lot][:fmea_type_id].present?
      params[:quality_lot][:fmea_type_id], params[:fmea_type_id] = params[:fmea_type_id], params[:quality_lot][:fmea_type_id]
      params[:quality_lot][:fmea_type_id] = params[:org_fmea_type_id] if params[:quality_lot][:fmea_type_id] == ""
    end

    if params[:quality_lot][:control_plan_id].present?
      params[:quality_lot][:control_plan_id], params[:control_plan_id] = params[:control_plan_id], params[:quality_lot][:control_plan_id]
      params[:quality_lot][:control_plan_id] = params[:org_control_plan_id] if params[:quality_lot][:control_plan_id] == ""
    end

    if params[:quality_lot][:run_at_rate_id].present?
      params[:quality_lot][:run_at_rate_id], params[:run_at_rate_id] = params[:run_at_rate_id], params[:quality_lot][:run_at_rate_id]
      params[:quality_lot][:run_at_rate_id] = params[:org_run_at_rate_id] if params[:quality_lot][:run_at_rate_id] == ""
    end
  end

  def lot_info

  end

  # GET po_headers/1/quality_lots
  # GET po_headers/1/quality_lots.json
  def index
    if params[:revision_id].present?
          @item_revision = ItemRevision.find(params[:revision_id])
          @quality_lots = @item_revision.quality_lots.order('created_at desc')
    elsif params[:item_id].present?
        @item = Item.find(params[:item_id])
        @quality_lots = @item.quality_lots.order('created_at desc')
    elsif params[:type].present?
      @quality_lots = QualityLot.lot_missing_location
    else
        @quality_lots = QualityLot.order('created_at desc')
    end

    i = 0
    respond_to do |format|
      format.html # index.html.erb
      format.json {

          if  user_signed_in? && current_user.is_vendor?
            @po_headers  = PoHeader.all
            organization_ids = current_user.organizations.collect(&:id)
            @po_headers =  @po_headers.delete_if {|entry| !organization_ids.include? entry[:organization_id]}
            @po_headers =   @po_headers.collect(&:id)
            @quality_lots = @quality_lots.delete_if {|entry| !@po_headers.include? entry[:po_header_id]}
          end
          @qality_lots = Array.new
          @quality_lots.each{ |quality_lot|
            qality_lot = Hash.new
            quality_lot.attributes.each do |key, value|
              qality_lot[key] = value
            end
            qality_lot[:index] = i

            if (can? :edit, quality_lot)
              qality_lot[:links] = CommonActions.object_crud_paths(nil, edit_quality_lot_path(quality_lot), nil)

            else
              qality_lot[:links] = ""
            end

            qality_lot[:lot_control_no] = CommonActions.linkable(quality_lot_path(quality_lot), quality_lot.lot_control_no)
            # quality_lot[:item_part_no] = CommonActions.linkable(item_path(quality_lot.po_line.item), quality_lot.po_line.item_alt_name.item_alt_identifier)

            # quality_lot[:item_with_revision] = CommonActions.linkable(item_path(quality_lot.item_revision.item,
            # revision_id: quality_lot.item_revision_id), quality_lot.po_line.item_alt_name.item_alt_identifier +
            # " (Revision: #{quality_lot.item_revision.item_revision_name})")

            qality_lot[:item_part_no] = CommonActions.linkable(item_path(quality_lot.item_revision.item,
            revision_id: quality_lot.item_revision_id), quality_lot.po_line.item_alt_name.item_alt_identifier)

            qality_lot[:item_revision_name] = quality_lot.item_revision.present? ? CommonActions.linkable(item_path(quality_lot.item_revision.item,
            revision_id: quality_lot.item_revision_id), quality_lot.item_revision.item_revision_name)  : ""
            if  user_signed_in? && current_user.is_customer?
              if can? :edit , quality_lot
                qality_lot[:po_identifier] = CommonActions.linkable(po_header_path(quality_lot.po_header), quality_lot.po_header.po_identifier)
              else
                qality_lot[:po_identifier] = quality_lot.po_header.po_identifier
              end
            else
              qality_lot[:po_identifier] = CommonActions.linkable(po_header_path(quality_lot.po_header), quality_lot.po_header.po_identifier)
            end
            qality_lot[:cost] = quality_lot.po_line.po_line_cost
            qality_lot[:inspection_level_name] = quality_lot.inspection_level.present? ? quality_lot.inspection_level.type_name : ""
            qality_lot[:inspection_method_name] =  quality_lot.inspection_method.present? ? quality_lot.inspection_method.type_name : ""
            qality_lot[:inspection_type_name] = quality_lot.inspection_type.present? ? quality_lot.inspection_type.type_name : ""
            qality_lot[:inspector_name] = quality_lot.lot_inspector.present? ? quality_lot.lot_inspector.name : ""
            qality_lot[:created_date] = quality_lot.created_at.strftime("%b %d, %y")
            qality_lot[:total_lots] = quality_lot.po_line.quality_lots.count
            i += 1
            @qality_lots.push(qality_lot)
          }
          render json: {:aaData => @qality_lots}
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
    @quality_lot = QualityLot.new(quality_lot_params)
    @quality_lot.lot_inspector = current_user

    respond_to do |format|
      if @quality_lot.save
        @quality_lot.after_create_values
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

      elsif @quality_lot.update_attributes(quality_lot_params)
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

    if params[:type] == "note" && params[:comment].present?
        Comment.process_comments(current_user, @quality_lot, [params[:comment]], params[:type])
        note = @quality_lot.comments.where(:comment_type => "note").order("created_at desc").first if @quality_lot
        note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
        note["created_user"] = note.created_by.name
        note["status"] = "success"
    else
        note = Hash.new
        note["status"] = "fail"
    end

    render json: {:result => note}
  end

  def material_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end

  def dimension_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end

  def gage_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end

  def psw_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end
  def csk_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end
  def package_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end

  def process_flow_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end

  def fmea_report
      @quality_lot = QualityLot.find(params[:id])
      render :layout => false
  end

  def report
    @quality_lots = QualityLot.report_data
    render :layout => false


  end
   private

    def set_disable_layout
      render :layout => false
    end

    def set_quality_lot
      @quality_lot = QualityLot.find(params[:id])
    end

    def quality_lot_params
      params.require(:quality_lot).permit(:po_header_id, :po_line_id, :item_revision_id, :inspection_level_id, :inspection_method_id,
                                          :inspection_type_id, :lot_active, :lot_control_no, :lot_created_id, :lot_finalized_at, :lot_inspector_id,
                                          :lot_notes, :lot_quantity, :lot_updated_id, :lot_aql_no, :fmea_type_id, :control_plan_id, :process_flow_id,
                                          :lot_shelf_idenifier, :lot_shelf_unit, :lot_shelf_number, :quality_lot_materials_attributes, :run_at_rate_id,
                                          :fai, :finished, :quantity_on_hand, :lot_status, :final_date)
    end

end
