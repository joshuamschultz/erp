class GlEntriesController < ApplicationController
  before_filter :set_page_info
  before_filter :set_autocomplete_values, only: [:create, :update]

  def set_page_info
      @menus[:general_ledger][:active] = "active"
  end

  def set_autocomplete_values
      params[:gl_entry][:gl_account_id], params[:gl_account_id] = params[:gl_account_id], params[:gl_entry][:gl_account_id]
      params[:gl_entry][:gl_account_id] = params[:org_gl_account_id] if params[:gl_entry][:gl_account_id] == ""
  end


  # GET /gl_entries
  # GET /gl_entries.json
  def index
      @gl_account=params[:gl_account]
      if params[:gl_account]

        @gl_entries = GlEntry.where(:gl_account_id => params[:gl_account])          
      else
        @gl_entries = GlEntry.all  
      end 
    respond_to do |format|
      format.html # index.html.erb
      format.json {         
          @gl_entries.select{|gl_entry| 
            if can? :edit, GlEntry
              gl_entry[:links] = CommonActions.object_crud_paths(nil, edit_gl_entry_path(gl_entry), gl_entry_path(gl_entry))
            else
              gl_entry[:links] =  ""
            end   
            gl_entry[:gl_entry_identifier] = CommonActions.linkable(gl_entry_path(gl_entry), gl_entry.gl_entry_identifier)
            gl_entry[:gl_account_name] = CommonActions.linkable(gl_account_path(gl_entry.gl_account), gl_entry.gl_account.gl_account_title)
            gl_entry[:gl_entry_description] = gl_entry.get_description_link
          }
          render json: {:aaData => @gl_entries}       
      }
    end
  end

  # GET /gl_entries/1
  # GET /gl_entries/1.json
  def show
    @gl_entry = GlEntry.find(params[:id])
    @attachable = @gl_entry
    @notes = @gl_entry.comments.where(:comment_type => "note").order("created_at desc") if @gl_entry 

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gl_entry }
    end
  end

  # GET /gl_entries/new
  # GET /gl_entries/new.json
  def new
    @gl_entry = GlEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gl_entry }
    end
  end

  # GET /gl_entries/1/edit
  def edit
    @gl_entry = GlEntry.find(params[:id])
    @gl_account = @gl_entry.gl_account
  end

  # POST /gl_entries
  # POST /gl_entries.json
  def create
    @gl_entry = GlEntry.new(params[:gl_entry])

    respond_to do |format|
      if @gl_entry.save
        format.html { redirect_to @gl_entry, notice: 'Gl entry was successfully created.' }
        format.json { render json: @gl_entry, status: :created, location: @gl_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @gl_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gl_entries/1
  # PUT /gl_entries/1.json
  def update
    @gl_entry = GlEntry.find(params[:id])

    respond_to do |format|
      if @gl_entry.update_attributes(params[:gl_entry])
        format.html { redirect_to @gl_entry, notice: 'Gl entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gl_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gl_entries/1
  # DELETE /gl_entries/1.json
  def destroy
    @gl_entry = GlEntry.find(params[:id])
    # if @gl_entry.gl_entry_credit
    #    CommonActions.update_gl_accounts_for_gl_entry(@gl_entry.gl_account.gl_account_title, 'decrement', @gl_entry.gl_entry_credit)
    #  end
    #  if @gl_entry.gl_entry_debit
    #    CommonActions.update_gl_accounts_for_gl_entry(@gl_entry.gl_account.gl_account_title, 'increment', @gl_entry.gl_entry_debit)
    #  end
    @gl_entry.destroy

    respond_to do |format|
      format.html { redirect_to gl_entries_url }
      format.json { head :no_content }
    end
  end

  def populate
     @gl_entry = GlEntry.find(params[:id])

        if params[:type] == "note" && params[:comment].present?
            Comment.process_comments(current_user, @gl_entry, [params[:comment]], params[:type])
            note = @gl_entry.comments.where(:comment_type => "note").order("created_at desc").first if @gl_entry
            note["time"] = note.created_at.strftime("%m/%d/%Y %H:%M")
            note["created_user"] = note.created_by.name
            note["status"] = "success"
        else
            note = Hash.new
            note["status"] = "fail"
        end

        render json: {:result => note}
  end
end
