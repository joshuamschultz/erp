class ReceivableLinesController < ApplicationController
  # GET receivables/1/receivable_lines
  # GET receivables/1/receivable_lines.json
  def index
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_lines = @receivable.receivable_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @receivable_lines }
    end
  end

  # GET receivables/1/receivable_lines/1
  # GET receivables/1/receivable_lines/1.json
  def show
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_line = @receivable.receivable_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @receivable_line }
    end
  end

  # GET receivables/1/receivable_lines/new
  # GET receivables/1/receivable_lines/new.json
  def new
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_line = @receivable.receivable_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @receivable_line }
    end
  end

  # GET receivables/1/receivable_lines/1/edit
  def edit
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_line = @receivable.receivable_lines.find(params[:id])
  end

  # POST receivables/1/receivable_lines
  # POST receivables/1/receivable_lines.json
  def create
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_line = @receivable.receivable_lines.build(params[:receivable_line])

    respond_to do |format|
      if @receivable_line.save
        format.html { redirect_to([@receivable_line.receivable, @receivable_line], :notice => 'Receivable line was successfully created.') }
        format.json { render :json => @receivable_line, :status => :created, :location => [@receivable_line.receivable, @receivable_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @receivable_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT receivables/1/receivable_lines/1
  # PUT receivables/1/receivable_lines/1.json
  def update
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_line = @receivable.receivable_lines.find(params[:id])

    respond_to do |format|
      if @receivable_line.update_attributes(params[:receivable_line])
        format.html { redirect_to([@receivable_line.receivable, @receivable_line], :notice => 'Receivable line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @receivable_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE receivables/1/receivable_lines/1
  # DELETE receivables/1/receivable_lines/1.json
  def destroy
    @receivable = Receivable.find(params[:receivable_id])
    @receivable_line = @receivable.receivable_lines.find(params[:id])
    @receivable_line.destroy

    respond_to do |format|
      format.html { redirect_to receivable_receivable_lines_url(receivable) }
      format.json { head :ok }
    end
  end
end
