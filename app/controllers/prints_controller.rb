class PrintsController < ApplicationController
  before_action :set_page_info

  autocomplete :print, :print_identifier, :full => true
  before_action :user_permissions


  def user_permissions
    if  user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
        authorize! :edit, Print
    end
  end

  def set_page_info
      @menus[:inventory][:active] = "active"
  end

  # GET /prints
  # GET /prints.json
  def index
    @prints = Print.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      @prins = Array.new
      format.json {
        @prints = @prints.collect{ |print|
          prind = Hash.new
          print.attributes.each do |key, value|
            prind[key] = value
          end
          attachment = print.attachment.attachment_fields
          print.attachment.attachment_fields.each  do |key, value|
            prind[key] = value
          end
          prind[:attachment_name] = CommonActions.linkable(print_path(print), attachment[:attachment_name])
          prind[:links] = CommonActions.object_crud_paths(nil, edit_print_path(print), nil)
          @prins.push(prind)
        }
        render json: {:aaData => @prins}
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
