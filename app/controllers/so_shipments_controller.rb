class SoShipmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :create
  before_action :set_page_info
  before_action :view_permissions, except: [:new]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_operations? || current_user.is_clerical? )
      authorize! :edit, SoShipment
    end
  end

  def user_permissions
    if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer?  )
      authorize! :edit, SoShipment
    end
  end

  def set_page_info
    unless user_signed_in? && (current_user.is_vendor? || current_user.is_customer?  )
      unless params[:type1].present? && params[:type2].present?
        @menus[:logistics][:active] = "active"
      else
        @menus[:reports][:active] = "active"
      end
    end
  end

  # GET /so_shipments
  # GET /so_shipments.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      @so_lins = Array.new
      format.json {
        if(params[:type] == "shipping")
            @so_lines =   SoLine.where(:so_line_status => "open").joins(:so_header).order("so_headers.so_due_date ASC").select{|so_line|
              so_lin = Hash.new
              so_line.attributes.each do |key, value|
                so_lin[key] = value
              end
              so_line = so_line_data_list(so_line, false)

              so_line.each do |key, value|
                so_lin[key] = value
              end
              so_line = SoLine.find(so_line["id"])
                so_lin[:so_due_date]= so_line.so_header.so_due_date ? so_line.so_header.so_due_date.strftime("%m-%d-%Y") : ""
                default_status = (so_line.so_header.po_header.present? && so_line.so_header.po_header.po_type.type_value == "transer") ? "ship_in" : "process"

                so_lin[:revision] = so_line.item_revision.present? ? so_line.item_revision.item_revision_name : so_line.item.item_revisions.last.item_revision_name
                so_lin[:so_line_shipping] = "<div class='so_line_shipping_input'><input so_line_id='#{so_line.id}' so_shipped_status='#{default_status}' class='shipping_input_field shipping_input_so_#{so_line.so_header.id}' type='text' value='0'></div>"
                so_lin[:so_line_lot]= CommonActions.get_quality_lot_div(so_line.id)
                so_lin[:so_line_location] = CommonActions.get_location_div(so_line.id)
                if can? :edit, SoShipment
                  so_lin[:so_identifier] = "<div style='background-color:#484848;height:30px;'><a href='/so_headers/#{so_line.so_header.id}' style='padding-left:10px;color: #8ec657;' >"+so_line.so_header.so_identifier+"</a>"

                  so_lin[:so_identifier] += "<a onclick='process_all_open(#{so_line.so_header.id}, $(this)); return false' class='pull-right btn btn-small btn-success' href='#'>Ship All</a>"
                  so_lin[:so_identifier] += "<a onclick='fill_po_items(#{so_line.so_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Fill</a></div>"
                  # so_line[:so_identifier] += "<a onclick='shipment_process(#{so_line.so_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Complete Shipment</a>"
                  so_lin[:links] = "<a onclick='item_locations(#{so_line.item_revision_id}); return false' class='btn-action glyphicons eye_open btn-default' data-toggle='modal' href='#modal-simple'><i></i></a>"
                  so_lin[:links] += "<a so_line_id='#{so_line.id}' so_shipped_status='#{default_status}' class='btn_save_shipped btn-action glyphicons check btn-success' href='#'><i></i></a> <div class='pull-right shipping_status'></div>"
                  so_lin[:links] += "<a so_line_id='#{so_line.id}' so_shipped_status='ship_close' class='btn_save_shipped_close btn-action   btn-success' href='#'>Close</a>"
                else
                  so_lin[:so_identifier] += ""
                  so_lin[:so_identifier] += ""
                  so_lin[:links] = ""

                end
                @so_lins.push(so_lin)
            }
            render json: {:aaData => @so_lins}
        elsif params[:type1].present? && params[:type2].present?
             @so_lines =  SoLine.where(:so_line_status => "open").joins(:so_header).where("so_headers.so_due_date >= ? AND so_headers.so_due_date <= ?",Date.today,  Date.today+6).select{|so_line|

                so_lin = Hash.new
                so_line.attributes.each do |key, value|
                  so_lin[key] = value
                end
                so_line = so_line_data_list(so_line, false)
                so_line.each do |key, value|
                  so_lin[key] = value
                end
                so_lin[:so_due_date]= so_line.so_header.so_due_date ? so_line.so_header.so_due_date.strftime("%m-%d-%Y") : ""
                so_lin[:so_line_shipping] = "<div class='so_line_shipping_input'><input so_line_id='#{so_line.id}' so_shipped_status='shipped' class='shipping_input_field shipping_input_so_#{so_line.so_header.id}' type='text' value='0'></div>"
                @so_lins.push(so_lin)
            }
            render json: {:aaData => @so_lins}
        else
            @item = Item.find(params[:item_id]) if params[:item_id].present?
            item_revision = ItemRevision.find(params[:revision_id]) if params[:revision_id].present?
            @quality_lot = QualityLot.find(params[:quality_lot_id]) if params[:quality_lot_id].present?
            # @so_ship_outs = SoShipment.where(:so_shipped_status => "ship_out").order("created_at desc").includes(:so_line)

            if item_revision
               @so_shipments = SoShipment.all_revision_shipments(item_revision.id)
            elsif @item
                if params[:type].present?
                  @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(@item.so_shipments) : SoShipment.open_shipments(@item.so_shipments)
                else
                  @so_shipments = SoShipment.all_shipments(@item.id)
                end
            elsif  @quality_lot
                  if params[:type].present?
                    @so_shipments = (params[:type] == "history") ? SoShipment.closed_shipments(@quality_lot.so_shipments) : SoShipment.open_shipments(@quality_lot.so_shipments)
                  else
                    @so_shipments = @quality_lot.so_shipments.where(:so_shipped_status => ["shipped","ship_out"])
                  end

            else
                if params[:type] == 'history'
                  @so_shipments = SoShipment.closed_shipments
                  #@so_shipments  =  @so_shipments +  @so_ship_outs
                  #@so_shipments = @so_shipments + SoShipment.where(:so_shipped_status => "ship_out")
                elsif params[:type] == "process"
                  @so_shipments =  SoShipment.open_shipments.where(:so_shipped_status => ["process", "ship_close", "ship_in"])
                else
                  @so_shipments = SoShipment.open_shipments.where(:so_shipped_status => ["shipped"])
                end

            end
            i = 0
            # @so_shipments = (@so_shipments.includes(:so_line).order(:so_line_id) + @so_ship_outs.order(:so_line_id)) .select{|so_shipment|
            @so_shipmnts = Array.new
            @so_shipments = @so_shipments.includes(:so_line).order(:so_line_id).select{|so_shipment|
                so_shipmnt = Hash.new
                so_shipment.attributes.each do |key, value|
                  so_shipmnt[key] = value
                end
                so_shipmnt[:index] =  i
                so_shipment = so_line_data_list(so_shipment, true)
                so_shipment.each do |key, value|
                  so_shipmnt[key] = value
                end
                so_shipment = SoShipment.find(so_shipment["id"])

                if params[:type] == "process"
                  ship_id = '"'+so_shipment.shipment_process_id+'"'
                  so_shipmnt[:shipment_process_id] = "<div style='height:30px;color:#8ec657;background-color: #484848;padding-left:10px;'>#{so_shipment.shipment_process_id}"
                  so_shipmnt[:shipment_process_id] += "<a onclick='shipment_process(#{ship_id}); return false' class='pull-right btn btn-small btn-success' href='#'>Complete Shipment</a></div>"
                end
                if can? :edit, SoShipment
                  so_shipmnt[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, edit_so_shipment_path(so_shipment), nil)
                else
                  so_shipmnt[:links] = ""
                end
                so_shipmnt[:so_shipped_date] = so_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")
                if params[:type] == "process"
                  so_shipmnt[:item_part_no] = params[:create_receivable] ?  so_shipment[:item_part_no] : so_shipment[:item_part_no]
                else
                  so_shipmnt[:item_part_no] = params[:create_receivable] ? so_shipment.receivable_checkbox(params[:type]).to_s + so_shipment[:item_part_no].to_s : so_shipment[:item_part_no]
                end
                i += 1
                @so_shipmnts.push(so_shipmnt)
            }
            render json: {:aaData => @so_shipmnts}
        end
      }
    end
  end

  def so_line_data_list(object, shipment)
    so_line = shipment ? object.so_line : object

      obj = Hash.new
      object.attributes.each do |key, value|
        obj[key] = value
      end
      obj[:so_identifier] = CommonActions.linkable(so_header_path(so_line.so_header), so_line.so_header.so_identifier)
      obj[:item_part_no] = so_line.item.present? ?  CommonActions.linkable(item_path(so_line.item), so_line.item_alt_name.item_alt_identifier, {revision_id: so_line.item_revision_id, item_alt_name_id: so_line.item_alt_name_id})   : ""
      if so_line.so_header.po_header.present? && so_line.so_header.po_header.po_type.type_value == "transer"
         obj[:customer_name] = CommonActions.linkable(organization_path(so_line.so_header.po_header.organization), so_line.so_header.po_header.organization.organization_name)
      else
        obj[:customer_name] = so_line.so_header.organization ? CommonActions.linkable(organization_path(so_line.so_header.organization), so_line.so_header.organization.organization_name) : "CHESS"
      end
      obj[:vendor_name] = so_line.organization ? CommonActions.linkable(organization_path(so_line.organization), so_line.organization.organization_name) : "CHESS"
      # object[:customer_name] = so_line.organization ? CommonActions.linkable(organization_path(so_line.so_header.organization), so_line.so_header.organization.organization_name) : "CHESS"
    obj[:lot] = ""

      if shipment && object.quality_lot_id && object.quality_lot_id > 0
        quality_lot = QualityLot.find(object.quality_lot_id)
        obj[:lot] =quality_lot.lot_control_no.split('-')[0]+"-"+"<a href='/quality_lots/#{quality_lot.id}'>#{quality_lot.lot_control_no.split('-')[1]}</a>" if quality_lot.present? && quality_lot.lot_control_no.present?
      end

    # object[:quality_level_name] = CommonActions.linkable(customer_quality_path(so_line.customer_quality), so_line.customer_quality.quality_name)
    obj[:so_line_quantity] = so_line.so_line_quantity
    obj[:so_line_quantity_shipped] = "<div class='so_line_shipping_total'>#{so_line.so_line_shipped}</div>"
    obj[:so_line_quantity_open] = "<div class='so_line_quantity_open'>#{so_line.so_line_quantity - so_line.so_line_shipped}</div>"
    obj
  end

  # GET /so_shipments/1
  # GET /so_shipments/1.json
  def show
    @so_shipment = SoShipment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @so_shipment }
    end
  end

  # GET /so_shipments/new
  # GET /so_shipments/new.json
  def new
    @so_shipment = SoShipment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @so_shipment }
    end
  end

  # GET /so_shipments/1/edit
  def edit
    @so_shipment = SoShipment.find(params[:id])
  end

  # POST /so_shipments
  # POST /so_shipments.json
  def create
    unless params[:so_shipment]['quality_lot_id'] == 'empty' || params[:so_shipment]['quality_lot_id'] == 'less'
      @so_shipment = SoShipment.new(so_shipment_params) #To delete in Sprint 7
###To uncommnet in Sprint 7
      # @quality_lot = QualityLot.find(params[:so_shipment]['quality_lot_id'])
      # lot_status =   @quality_lot.quality_histories.last.quality_status if @quality_lot.quality_histories.last.present? && @quality_lot.quality_histories.last.quality_status.present?
      # if lot_status.present? && lot_status == 'accepted'
      #   @so_shipment = SoShipment.new(params[:so_shipment])
      # else
      #   @so_shipment = 2
      # end
###To uncommnet in Sprint 7      End
    else
      @so_shipment = params[:so_shipment]['quality_lot_id'] == 'empty' ? 0 : 1
    end

    respond_to do |format|
      res = Hash.new
      if @so_shipment == 0 || @so_shipment == 1
          format.html { render action: "new" }
          res["lot"] = @so_shipment == 0 ? 'Please receive the lot' : 'ship more than a lot has'
          format.json { render json: {errors:  res} }
##To uncomment in Sprint 7
      # elsif @so_shipment == 2
      #     format.html { render action: "new" }
      #     res["lot"] = 'Lot is not accepted'
      #     format.json { render json: {errors:  res} }
## To uncomment in Sprint 7 End
      else
        if @so_shipment.save
          @so_shipment.set_quality_on_hand
          # @so_shipment.so_line.update_so_total
          so_shipmnt = Hash.new
          @so_shipment.attributes.each do |key, value|
            so_shipmnt[key] = value
          end
          so_shipmnt["quantity_open"] = @so_shipment.so_line.so_line_quantity - @so_shipment.so_line.so_line_shipped
          so_shipmnt["shipped_status"] = @so_shipment.so_line.so_line_status
          so_shipmnt["shipment_shipped_status"] = @so_shipment.close_all_so_lines?(@so_shipment.id)
          so_shipmnt["quantity_on_hand"] = @so_shipment.quality_lot.quantity_on_hand
          format.html { redirect_to so_shipmnt, notice: 'SO shipment was successfully created.' }
          format.json { render json: so_shipmnt, status: :created, location: @so_shipment }
        else
          format.html { render action: "new" }
          format.json { render json: {errors:  @so_shipment.errors.first} }
        end
      end
    end
  end

  # PUT /so_shipments/1
  # PUT /so_shipments/1.json
  def update
    @so_shipment = SoShipment.find(params[:id])

    respond_to do |format|
      if @so_shipment.update_attributes(so_shipment_params)
        # format.html { redirect_to @so_shipment, notice: 'So shipment was successfully updated.' }
        format.html { redirect_to so_shipments_path, notice: 'SO shipment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @so_shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /so_shipments/1
  # DELETE /so_shipments/1.json
  def destroy
    @so_shipment = SoShipment.find(params[:id])
    SoShipment.update_quality_on_hand(@so_shipment)
    # status = @so_shipment.so_shipped_status
    @so_shipment.destroy

    respond_to do |format|
      # if status == "process"
      format.html { redirect_to new_so_shipment_path, notice: 'SO shipment was successfully deleted.' }
      format.json { head :no_content }
      # else
      #   format.html { redirect_to so_shipments_url, notice: 'SO shipment was successfully deleted.' }
      #   format.json { head :no_content }
      # end
    end
  end
  private

    def set_so_shipment
      @so_shipment = SoShipment.find(params[:id])
    end

    def so_shipment_params
      params.require(:so_shipment).permit(:so_line_id, :so_shipment_updated_id, :so_shipment_created_id, :quality_lot_id,
                                          :so_shipped_cost, :so_shipped_count, :so_shipped_shelf, :so_shipped_unit, :so_shipped_status, :shipment_process_id, :so_header_id, :item_id)
    end
end
