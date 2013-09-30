class ReceivablesController < ApplicationController
  before_filter :set_autocomplete_values, only: [:create, :update]

  before_filter :set_page_info

  def set_page_info
      @menus[:accounts][:active] = "active"
  end

  def set_autocomplete_values
    params[:receivable][:so_header_id], params[:so_header_id] = params[:so_header_id], params[:receivable][:so_header_id]
    params[:receivable][:so_header_id] = params[:org_so_header_id] if params[:receivable][:so_header_id] == ""
  end

  # GET /receivables
  # GET /receivables.json
  def index
    @receivables = Receivable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @receivables = @receivables.select{|receivable|
              receivable[:receivable_identifier] = CommonActions.linkable(receivable_path(receivable), receivable.receivable_identifier)
              receivable[:so_identifier] = receivable.so_header.present? ? CommonActions.linkable(so_header_path(receivable.so_header), receivable.so_header.so_identifier) : "-"
              receivable[:customer_name] = receivable.organization.present? ? CommonActions.linkable(organization_path(receivable.organization), receivable.organization.organization_name) : "-"
              receivable[:links] = CommonActions.object_crud_paths(nil, edit_receivable_path(receivable), nil)
          }
          render json: {:aaData => @receivables}
      }
    end
  end

  # GET /receivables/1
  # GET /receivables/1.json
  def show
    @receivable = Receivable.find(params[:id])
    @so_header = @receivable.so_header
    @attachable = @receivable

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @receivable }
    end
  end

  # GET /receivables/new
  # GET /receivables/new.json
  def new
    @receivable = Receivable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @receivable }
    end
  end

  # GET /receivables/1/edit
  def edit
    @receivable = Receivable.find(params[:id])
    @so_header = @receivable.so_header
  end

  # POST /receivables
  # POST /receivables.json
  def create
    @receivable = Receivable.new(params[:receivable])

    respond_to do |format|
      if @receivable.save
        format.html { redirect_to edit_receivable_path(@receivable), notice: 'Receivable was successfully created.' }
        format.json { render json: @receivable, status: :created, location: @receivable }
      else
        format.html { render action: "new" }
        format.json { render json: @receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /receivables/1
  # PUT /receivables/1.json
  def update
    @receivable = Receivable.find(params[:id])

    respond_to do |format|
      if @receivable.update_attributes(params[:receivable])
        format.html { redirect_to @receivable, notice: 'Receivable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @receivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivables/1
  # DELETE /receivables/1.json
  def destroy
    @receivable = Receivable.find(params[:id])
    @receivable.destroy

    respond_to do |format|
      format.html { redirect_to receivables_url }
      format.json { head :no_content }
    end
  end
end
