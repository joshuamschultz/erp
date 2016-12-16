class PoShipmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :create
  before_action :set_page_info

  before_action :view_permissions, except: [:new,:index]
  before_action :user_permissions


  def view_permissions
    if  user_signed_in? && ( current_user.is_operations? || current_user.is_clerical? || current_user.is_vendor? )
      authorize! :edit, PoShipment
    end
  end

  def user_permissions
    if  user_signed_in? && current_user.is_customer?
      authorize! :edit, PoShipment
    end
  end

  def set_page_info
    unless user_signed_in? && (current_user.is_vendor? || current_user.is_customer?  )
      @menus[:logistics][:active] = "active"
    end
  end

  # GET /po_shipments
  # GET /po_shipments.json
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json {

        if params[:type] == "shipping"
            @po_lins = Array.new
            @po_lines = PoLine.where(:po_line_status => "open").includes(:po_header).select{|po_line|
                po_lin = Hash.new
                po_line = po_line.po_line_data_list(po_line, false)
                po_line.each do |key, value|
                  po_lin[key] = value
                end
                po_line = PoLine.find(po_line["id"])
                po_line.attributes.each do |key, value|
                  po_lin[key] = value
                end
                po_lin[:lot] = ""
                po_lin[:revision] = po_line.item_revision.present? ? po_line.item_revision.item_revision_name : po_line.item.item_revisions.last.item_revision_name

                # po_line = so_line_data_list(po_line, false)
                @po_lins.push(po_lin)
             }
            render json: {:aaData => @po_lins}
        else
            @item = Item.find(params[:item_id]) if params[:item_id].present?
            item_revision = ItemRevision.find(params[:revision_id]) if params[:revision_id].present?
            if item_revision
               @po_shipments = PoShipment.all_revision_shipments(item_revision.id)
            elsif @item
              if params[:type].present?
                @po_shipments = (params[:type] == "history") ? PoShipment.closed_shipments(@item.po_shipments).order("created_at desc") : PoShipment.open_shipments(@item.po_shipments).order("created_at desc")
              else
                @po_shipments = PoShipment.all_shipments(@item.id)
              end
            else
              @po_shipments = (params[:type] == "history") ? PoShipment.closed_shipments(nil).order("created_at desc") : PoShipment.open_shipments(nil).order("created_at desc")
            end
            @po_shipments = @po_shipments.includes(:po_line).order(:po_line_id)
            if  user_signed_in? && current_user.is_vendor?
            #organization_ids = current_user.organizations.collect(&:id)
            organization_ids = current_user.organizations.where("organization_type_id =? ", MasterType.find_by_type_value('vendor').id).collect(&:id)

            @po_shipments =  @po_shipments.delete_if {|entry| !organization_ids.include? entry.po_line.po_header.organization_id}

            end
            i = 0
            @po_shipmnts = Array.new
            @po_shipments = @po_shipments.select{|po_shipment|
                po_shipmnt = Hash.new

                po_shipmnt[:index] =  i
                po_shipment = po_shipment.po_line.po_line_data_list(po_shipment, true)
                po_shipment.each do |key, value|
                  po_shipmnt[key] = value
                end
                po_shipment = PoShipment.find(po_shipment["id"])

                po_shipment.attributes.each do |key, value|
                  po_shipmnt[key] = value
                end
                # po_shipment = so_line_data_list(po_shipment, true)
                po_shipmnt[:po_shipped_date] = po_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")

                po_shipmnt[:po_line_cost] = po_shipment.po_line.po_line_cost
                if can? :edit, PoShipment
                  po_shipmnt[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, edit_po_shipment_path(po_shipment), nil)
                else
                  po_shipmnt[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, nil, nil)
                end
                po_shipmnt[:item_part_no] = (params[:create_payable].present? ? po_shipment.payable_checkbox(params[:type]) : "").to_s + po_shipment[:item_part_no].to_s
                if po_shipment
                  quality_lot = po_shipment.quality_lot
                if can? :edit, PoShipment

                  po_shipmnt[:lot] =  quality_lot.present? && quality_lot.lot_control_no.present? ? "<a href='/quality_lots/#{quality_lot.id}'>#{quality_lot.lot_control_no.split('-')[1]}</a>"  : ""
                else
                  po_shipmnt[:lot]= ""
                end
                else
                   po_shipmnt[:lot]= ""
                end
                i += 1
                @po_shipmnts.push(po_shipmnt)
            }
            render json: {:aaData => @po_shipmnts}
        end
      }
    end
  end


  # def po_line_data_list(object, shipment)
  #   po_line = shipment ? object.po_line : object
  # object[:lot] = ""

  #     if shipment && object.quality_lot_id && object.quality_lot_id > 0
  #       quality_lot = QualityLot.find(object.quality_lot_id)
  #       object[:lot] =quality_lot.lot_control_no.split('-')[0]+"-"+"<a href='/quality_lots/#{quality_lot.id}'>#{quality_lot.lot_control_no.split('-')[1]}</a>"
  #     end
  # end

  # GET /po_shipments/1
  # GET /po_shipments/1.json
  def show
    @po_shipment = PoShipment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @po_shipment }
    end
  end

  # GET /po_shipments/new
  # GET /po_shipments/new.json
  def new
    @po_shipment = PoShipment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @po_shipment }
    end
  end

  # GET /po_shipments/1/edit
  def edit
    @po_shipment = PoShipment.find(params[:id])
  end

  # POST /po_shipments
  # POST /po_shipments.json
  def create
    @po_shipment = PoShipment.new(po_shipment_params)

    respond_to do |format|
      if @po_shipment.save


        @item_lot = ItemLot.create(item_id: @po_shipment.po_line.item_id)
        inspection_level = MasterType.where(:type_name => 'Level 1', :type_category => 'inspection_level').pluck(:id)[0]
        inspection_method = MasterType.where(:type_name => 'single', :type_category => 'inspection_method').pluck(:id)[0]
        inspection_type = MasterType.where(:type_name => 'Normal', :type_category => 'inspection_type').pluck(:id)[0]

        @quality_lot = QualityLot.new(:po_header_id => @po_shipment.po_line.po_header_id, :po_line_id => @po_shipment.po_line.id, :item_revision_id => @po_shipment.po_line.item_revision_id, :lot_quantity => @po_shipment.po_shipped_count, :quantity_on_hand => @po_shipment.po_shipped_count,
          :inspection_level_id => inspection_level, :inspection_method_id => inspection_method, :inspection_type_id => inspection_type, :lot_unit => @po_shipment.po_shipped_unit, :lot_self => @po_shipment.po_shipped_shelf)
        @quality_lot.lot_inspector = current_user

        if @quality_lot.save
          # lot_count = (@po_shipment.po_line.item.quality_lots.count == 0) ? 1 : self.po_line.item.quality_lots.count
          @item_lot.update_attribute(:quality_lot_id , @quality_lot.id)
          # @quality_lot.set_lot_control_no
        end



        @po_shipment.update_attribute(:quality_lot_id , @quality_lot.id)
        quality_lot = @po_shipment.quality_lot

        # unless quality_lot.lot_control_no.present?
        #   quality_lot.delete
        #   @po_shipment.delete
        # end
        # else
                  # @po_shipment.set_quality_on_hand
          quality_lot = @po_shipment.quality_lot
          po_shipmnt = Hash.new
          @po_shipment.attributes.each do |key, value|
            po_shipmnt[key] = value
          end
          po_shipmnt["quantity_open"] = @po_shipment.po_line.po_line_quantity - @po_shipment.po_line.po_line_shipped
          po_shipmnt["shipped_status"] = @po_shipment.po_line.po_line_status
          po_shipmnt["po_shipped_status"] = @po_shipment.po_line.po_header.po_status
          po_shipmnt["shipment_shipped_status"] = @po_shipment.close_all_po_lines?(@po_shipment.id)
          po_shipmnt["po_shipped_id"] = @po_shipment.po_line.po_header_id
          po_shipmnt["part_number"] = @po_shipment.po_line.item.item_part_no
          po_shipmnt["po"]   = @po_shipment.po_line.po_header.po_identifier
          po_shipmnt["customer"] = @po_shipment.po_line.organization.organization_name if @po_shipment.po_line.organization
          po_shipmnt["lot_id"] = quality_lot.id if quality_lot.present?
          po_shipmnt["company_name"] =  CompanyInfo.first.company_name
          format.html { redirect_to po_shipmnt, notice: 'PO received was successfully created.' }
          format.json { render json: po_shipmnt, status: :created, location: @po_shipment }
        # end

      else
        format.html { render action: "new" }
        format.json { render json: {errors:  @po_shipment.errors.first} }
      end
    end

  end

  # PUT /po_shipments/1
  # PUT /po_shipments/1.json
  def update
    @po_shipment = PoShipment.find(params[:id])

    respond_to do |format|
      if @po_shipment.update_attributes(po_shipment_params)
        if  @po_shipment.quality_lot_id
          @quality_lot = QualityLot.find(@po_shipment.quality_lot_id)
          @quality_lot.update_attributes(:lot_quantity => @po_shipment.po_shipped_count, :lot_unit => @po_shipment.po_shipped_unit, :lot_self => @po_shipment.po_shipped_shelf)
        end
        format.html { redirect_to po_shipments_path, notice: 'PO shipment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @po_shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /po_shipments/1
  # DELETE /po_shipments/1.json
  def destroy
    @po_shipment = PoShipment.find(params[:id])
    @po_shipment.destroy

    respond_to do |format|
      format.html { redirect_to po_shipments_url }
      format.json { head :no_content }
    end
  end
  private

     private

    def set_po_shipment
      @po_shipment = PoShipment.find(params[:id])
    end

    def po_shipment_params
      params.require(:po_shipment).permit(:po_line_id, :po_shipment_created_id, :po_shipment_updated_id,
                                           :po_shipped_count, :po_shipped_cost, :po_shipped_shelf, :po_shipped_unit, :po_shipped_status, :quality_lot_id)
    end
end
