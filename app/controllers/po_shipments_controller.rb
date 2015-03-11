class PoShipmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :set_page_info

  before_filter :view_permissions, except: [:new,:index]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && ( current_user.is_operations? || current_user.is_clerical? )
        authorize! :edit, PoShipment
    end 
  end

  def user_permissions
   if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer?  )
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
            @po_lines = PoLine.where(:po_line_status => "open").includes(:po_header).select{|po_line|
                po_line = po_line.po_line_data_list(po_line, false)
                po_line[:lot] = ""
                # po_line = so_line_data_list(po_line, false)
             }
            render json: {:aaData => @po_lines}
        else
            @item = Item.find(params[:item_id]) if params[:item_id].present?
            if @item
               if params[:type].present?
                @po_shipments = (params[:type] == "history") ? PoShipment.closed_shipments(@item.po_shipments).order("created_at desc") : PoShipment.open_shipments(@item.po_shipments).order("created_at desc")
               else
                @po_shipments = PoShipment.all_shipments(@item.id)
                end  
            else
                @po_shipments = (params[:type] == "history") ? PoShipment.closed_shipments(nil).order("created_at desc") : PoShipment.open_shipments(nil).order("created_at desc")
            end
            i = 0
            @po_shipments = @po_shipments.includes(:po_line).order(:po_line_id).select{|po_shipment|
                po_shipment[:index] =  i
                po_shipment = po_shipment.po_line.po_line_data_list(po_shipment, true)

                # po_shipment = so_line_data_list(po_shipment, true)  
                po_shipment[:po_shipped_date] = po_shipment.created_at.strftime("%Y-%m-%d at %I:%M %p")
                if can? :edit, PoShipment
                  po_shipment[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, edit_po_shipment_path(po_shipment), nil)
                else
                  po_shipment[:links] = params[:type] == "history" ? "" : CommonActions.object_crud_paths(nil, nil, nil)
                end
                po_shipment[:item_part_no] = (params[:create_payable].present? ? po_shipment.payable_checkbox(params[:type]) : "") + po_shipment[:item_part_no]
                if po_shipment
                  quality_lot = po_shipment.quality_lot
                if can? :edit, PoShipment

                  po_shipment[:lot] =  quality_lot.present? ? "<a href='/quality_lots/#{quality_lot.id}'>#{quality_lot.lot_control_no.split('-')[1]}</a>"  : "" 
                else
                  po_shipment[:lot]= ""
                end
                else
                   po_shipment[:lot]= ""
                end
                i += 1
            }
            render json: {:aaData => @po_shipments}
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
    @po_shipment = PoShipment.new(params[:po_shipment])

    respond_to do |format|
      if @po_shipment.save 
        inspection_level = MasterType.where(:type_name => 'Level 1', :type_category => 'inspection_level').pluck(:id)[0]                       
        inspection_method = MasterType.where(:type_name => 'single', :type_category => 'inspection_method').pluck(:id)[0]
        inspection_type = MasterType.where(:type_name => 'Normal', :type_category => 'inspection_type').pluck(:id)[0]       
        @quality_lot = QualityLot.create(:po_header_id => @po_shipment.po_line.po_header_id, :po_line_id => @po_shipment.po_line.id, :item_revision_id => @po_shipment.po_line.item_revision_id, :lot_quantity => @po_shipment.po_shipped_count, :quantity_on_hand => @po_shipment.po_shipped_count,:inspection_level_id => inspection_level, :inspection_method_id => inspection_method, :inspection_type_id => inspection_type)            
        @quality_lot.lot_inspector = current_user

        if     @quality_lot.save
          current_count = 0
          if   @quality_lot.po_line.item.quality_lots.present?
    
            p  quality_lot_id =   @quality_lot.po_line.item.quality_lots.maximum(:id)-1 

 
            p  maximum_lot = QualityLot.find(quality_lot_id).lot_control_no

        
            p current_count = maximum_lot.nil? ? 0 : maximum_lot.split("-")[1].to_i
     

        
          end


          min = (Time.now.min.to_i <10 ) ? "0"+Time.now.min.to_s : Time.now.min.to_s


          control_string = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
          CommonActions.current_hour_letter + min.to_s
          # unless  maximum_lot.nil?      
          letter = '@'

          begin
            letter = letter.next!
            # current_count = current_count + 1
            @max_control_string = MaxControlString.where(:control_string => control_string+letter)
          end while(@max_control_string.present?)     
          MaxControlString.create(:control_string => control_string+letter)  

           temp = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
           CommonActions.current_hour_letter + min.to_s  + "#{letter}-" + (current_count+1).to_s

          temp_number = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
          CommonActions.current_hour_letter + min.to_s  + "#{letter}-"

          temp_letter = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
          CommonActions.current_hour_letter + min.to_s

           @quality_lot.update_attribute(:lot_control_no , temp)

                     pre_control_no=  QualityLot.last.id-1
          pre_control_no = QualityLot.find(pre_control_no).lot_control_no
          
          if pre_control_no .present?
            @quality_lot.po_line.item.quality_lots.each do |quality_lot|
              if quality_lot.lot_control_no.present?
                p "=============="

                  p quality_lot.lot_control_no
                p "======"
                if  @quality_lot.lot_control_no == quality_lot.lot_control_no
                    letter = letter.next!
                    current_count = current_count +1
                    temp = temp_letter+"#{letter}-"+current_count.to_s  
                  elsif     @quality_lot.lot_control_no.split("-")[1].to_i ==  quality_lot.lot_control_no.split("-")[1].to_i
                    current_count = current_count +1
                    temp = temp_number+current_count.to_s
                  end
                end
              end

            @quality_lot.update_attribute(:lot_control_no , temp)
            end 
        end
        # @quality_lot.save 
        # @quality_lot.after_create_values
        
        @po_shipment.update_attribute(:quality_lot_id , @quality_lot.id)
        # @po_shipment.set_quality_on_hand           
        quality_lot = @po_shipment.quality_lot 
        @po_shipment["quantity_open"] = @po_shipment.po_line.po_line_quantity - @po_shipment.po_line.po_line_shipped
        @po_shipment["shipped_status"] = @po_shipment.po_line.po_line_status   
        @po_shipment["part_number"] = @po_shipment.po_line.item.item_part_no
        @po_shipment["po"]   = @po_shipment.po_line.po_header.po_identifier
        @po_shipment["customer"] = @po_shipment.po_line.organization.organization_name if @po_shipment.po_line.organization
        @po_shipment["control_number"] = quality_lot.lot_control_no if quality_lot.present?
        @po_shipment["company_name"] =  CompanyInfo.first.company_name
        format.html { redirect_to @po_shipment, notice: 'PO received was successfully created.' }
        format.json { render json: @po_shipment, status: :created, location: @po_shipment }
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
      if @po_shipment.update_attributes(params[:po_shipment])
        if  @po_shipment.quality_lot_id
          @quality_lot = QualityLot.find(@po_shipment.quality_lot_id)
          @quality_lot.update_attribute(:lot_quantity , @po_shipment.po_shipped_count)
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
end
