class CheckEntriesController < ApplicationController
  # GET /check_entries
  # GET /check_entries.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
          @check_entries = CheckEntry.all.select{|check_entry| 
            check_entry[:links] = CommonActions.object_crud_paths(nil, edit_check_entry_path(check_entry), check_entry_path(check_entry))
          }
          render json: {:aaData => @check_entries}
      }
    end
  end

  # GET /check_entries/1
  # GET /check_entries/1.json
  def show
    @check_entry = CheckEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_entry }
    end
  end

  # GET /check_entries/new
  # GET /check_entries/new.json
  def new
    @check_entry = CheckEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_entry }
    end
  end

  # GET /check_entries/1/edit
  def edit
    @check_entry = CheckEntry.find(params[:id])
  end

  # POST /check_entries
  # POST /check_entries.json
  def create
    @check_entry = CheckEntry.new(params[:check_entry])

    respond_to do |format|
      if @check_entry.save
        format.html { redirect_to @check_entry, notice: 'Check entry was successfully created.' }
        format.json { render json: @check_entry, status: :created, location: @check_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @check_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_entries/1
  # PUT /check_entries/1.json
  def update
    @check_entry = CheckEntry.find(params[:id])

    respond_to do |format|
      if @check_entry.update_attributes(params[:check_entry])
        format.html { redirect_to @check_entry, notice: 'Check entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_entries/1
  # DELETE /check_entries/1.json
  def destroy
    @check_entry = CheckEntry.find(params[:id])
    @check_entry.destroy

    respond_to do |format|
      format.html { redirect_to check_entries_url }
      format.json { head :no_content }
    end
  end

  def generate_check_entry
    if params[:serial_no].present? && params[:serial_end].present?
        for serial in params[:serial_no].to_i..params[:serial_end].to_i
            @check_entry = CheckEntry.new(check_active: true, check_code: serial, check_identifier: serial)
            @check_entry.save
        end
    end
    redirect_to check_entries_url
  end

end
