class PrintsController < ApplicationController
  before_filter :set_page_info

  autocomplete :print, :print_identifier, :full => true

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  # GET /prints
  # GET /prints.json
  def index
    @prints = Print.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @prints = @prints.collect{ |print|
          attachment = print.attachment.attachment_fields
          attachment[:attachment_name] = CommonActions.linkable(print_path(print), attachment.attachment_name)
          attachment[:links] = CommonActions.object_crud_paths(nil, edit_print_path(print), nil)
          attachment
        }
        render json: {:aaData => @prints}
      }
    end
  end

  # GET /prints/1
  # GET /prints/1.json
  def show
    @print = Print.find(params[:id])
    @attachment = @print.attachment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @print }
    end
  end

  # GET /prints/new
  # GET /prints/new.json
  def new
    @print = Print.new
    @print.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @print }
    end
  end

  # GET /prints/1/edit
  def edit
    @print = Print.find(params[:id])
    @attachment = @print.attachment
  end

  # POST /prints
  # POST /prints.json
  def create
    @print = Print.new(params[:print])

    respond_to do |format|
      @print.attachment.created_by = current_user
      if @print.save
        CommonActions.notification_process("Print", @print)
        format.html { redirect_to prints_path, notice: 'Print was successfully created.' }
        format.json { render json: @print, status: :created, location: @print }
      else
        format.html { render action: "new" }
        format.json { render json: @print.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prints/1
  # PUT /prints/1.json
  def update
    @print = Print.find(params[:id])

    respond_to do |format|
      @print.attachment.updated_by = current_user
      if @print.update_attributes(params[:print])
        CommonActions.notification_process("Print", @print)
        format.html { redirect_to prints_path, notice: 'Print was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @print.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prints/1
  # DELETE /prints/1.json
  def destroy
    @print = Print.find(params[:id])
    @print.destroy

    respond_to do |format|
      format.html { redirect_to prints_path, notice: 'Print was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
