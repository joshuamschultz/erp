class SoHeadersController < ApplicationController
  before_action :find_relations, only: [:index]
  before_action :set_page_info
  before_action :set_autocomplete_values, only: [:create, :update]
  before_action :set_so_header, only: %i[show edit update destroy, populate, so_info, report, pick_report, packing_report]

  autocomplete :so_header, :so_identifier, :full => true

  def set_page_info
    unless user_signed_in? && current_user.is_vendor?
      @menus[:sales][:active] = "active"
    end
  end

  def set_autocomplete_values
    params[:so_header][:organization_id], params[:organization_id] = params[:organization_id], params[:so_header][:organization_id]
    params[:so_header][:organization_id] = params[:org_organization_id] if params[:so_header][:organization_id] == ""
  end

  def get_autocomplete_items(parameters)
    items = active_record_get_autocomplete_items(parameters)
    if params[:organization_id].present?
      items = items.where(:organization_id => params[:organization_id])
    end
    items
  end

  def find_relations
    params[:so_status] ||= nil

    if params[:organization_id].present?
      @organization = Organization.find(params[:organization_id])
      @so_headers = @organization.present? ? @organization.sales_orders : []
    elsif params[:item_revision_id].present?
      @item_revision = ItemRevision.find(params[:item_revision_id])
      @so_headers = @item_revision.present? ? @item_revision.sales_orders : []
    elsif params[:item_alt_name_id].present?
      @item_alt_name = ItemAltName.find(params[:item_alt_name_id])
      @so_headers  = @item_alt_name.present? ? @item_alt_name.sales_orders(@item_alt_name.current_revision).order("created_at desc")  : []
    else
      @so_headers = SoHeader.order("created_at desc")
    end

    @so_headers = @so_headers.status_based_sos(params[:so_status]) if params[:so_status].present? && @so_headers.any?
  end

  def index
    # TODO: deleting empty SO should be moved to a job at night - not every load
    if @so_headers.find_by_so_identifier("Unassigned").present? and !request.xhr?
      @so_headers.find_by_so_identifier("Unassigned").delete
      redirect_to action: "index"
    elsif params[:so_status] || request.xhr?
      @so_headers = SoHeader.status_based_sos(params[:so_status].present? ? params[:so_status] : 'open')
      respond_to do |format|
        format.html # index.html.erb
        format.json {
          @so_header_result = []
          @so_headers.each do |so_header|
            data = {}
            data['so_id'] = so_header.so_identifier
            data['customer_name'] = ""
            data['bill_to_address_name'] = Address.find(so_header.so_bill_to_id).try(:address_title).to_s
            data['ship_to_address_name'] = Address.find(so_header.so_ship_to_id).try(:address_title).to_s
            data['so_cofc'] = so_header.so_cofc.to_s
            data['so_squality'] = so_header.so_squality
            data['so_status']= so_header.so_status
            data['links'] = ''
            @so_header_result << data
          end
          render json: {:aaData => @so_header_result}
        }
      end

    else
      @so_headers = SoHeader.status_based_sos("open")
    end
  end

  def show
    @attachable = @so_header
    @notes = @so_header.present? ? @so_header.comments.where(:comment_type => "note").order("created_at desc") : []
    @attachment = @so_header.attachments.new
  end

  def new
    @so_header = SoHeader.new
  end

  def edit
  end

  def create
    @so_header = SoHeader.new(so_header_params)

    respond_to do |format|
      if @so_header.save
        format.html { redirect_to new_so_header_so_line_path(@so_header), notice: "So header was successfully created." }
        format.json { render json: @so_header, status: :created, location: @so_header }
      else
        format.html { render action: "new" }
        format.json { render json: @so_header.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @so_header.update_attributes(so_header_params)
        format.html { redirect_to new_so_header_so_line_path(@so_header), notice: "So header was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @so_header.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @so_header.destroy
  end

  def populate
    if params[:type] == "note" && params[:comment].present?
      Comment.process_comments(current_user, @so_header, [params[:comment]], params[:type])
      note = @so_header.comments.where(:comment_type => "note").order("created_at desc").first if @so_header
      note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
      note["created_user"] = note.created_by.name
      note["status"] = "success"
    else
      note = Hash.new
      note["status"] = "fail"
    end

    render json: { :result => note }
  end

  def so_info
    @organization = @so_header.organization if @so_header
    if @organization
      render :layout => false
    else
      render :text => "" and return
    end
  end

  def report
    @so_header ||= SoHeader.find(params[:id])
    render :layout => false
  end

  def packing_report
    @so_header ||= SoHeader.find(params[:id])
    @company_info = CompanyInfo.first
    render :layout => false
  end

  def pick_report
    @so_header ||= SoHeader.find(params[:id])
    @company_info = CompanyInfo.first
    render :layout => false
  end

  private

  def set_so_header
    @so_header = SoHeader.find(params[:id])
  end

  def so_header_params
    params.require(:so_header).permit(:so_bill_to_id, :so_cofc, :so_comments, :so_identifier, :so_notes, :so_due_date,
                                      :so_ship_to_id, :so_squality, :so_status, :so_total, :organization_id, :so_header_customer_po)
  end

  def genarate_pdf
    p @so_header
    html = render_to_string(:layout => false, :partial => "so_headers/sales_report")
    kit = PDFKit.new(html, :page_size => "A4")
    # Get an inline PDF
    kit.to_pdf
    # Save the PDF to a file
    path = Rails.root.to_s + "/public/sales_report"
    if File.directory? path
      path = path + "/" + @so_header.so_identifier.to_s + ".pdf"
      kit.to_file(path)
    else
      Dir.mkdir path
      path = path + "/" + @so_header.so_identifier.to_s + ".pdf"
      kit.to_file(path)
    end
  end
end
