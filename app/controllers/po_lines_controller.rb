class PoLinesController < ApplicationController
  # GET po_headers/1/po_lines
  # GET po_headers/1/po_lines.json
  def index
    @po_header = PoHeader.find(params[:po_header_id])
    @po_lines = @po_header.po_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @po_lines }
    end
  end

  # GET po_headers/1/po_lines/1
  # GET po_headers/1/po_lines/1.json
  def show
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @po_line }
    end
  end

  # GET po_headers/1/po_lines/new
  # GET po_headers/1/po_lines/new.json
  def new
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @po_line }
    end
  end

  # GET po_headers/1/po_lines/1/edit
  def edit
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])
  end

  # POST po_headers/1/po_lines
  # POST po_headers/1/po_lines.json
  def create
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.build(params[:po_line])

    respond_to do |format|
      if @po_line.save
        format.html { redirect_to([@po_line.po_header, @po_line], :notice => 'Po line was successfully created.') }
        format.json { render :json => @po_line, :status => :created, :location => [@po_line.po_header, @po_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @po_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT po_headers/1/po_lines/1
  # PUT po_headers/1/po_lines/1.json
  def update
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])

    respond_to do |format|
      if @po_line.update_attributes(params[:po_line])
        format.html { redirect_to([@po_line.po_header, @po_line], :notice => 'Po line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @po_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE po_headers/1/po_lines/1
  # DELETE po_headers/1/po_lines/1.json
  def destroy
    @po_header = PoHeader.find(params[:po_header_id])
    @po_line = @po_header.po_lines.find(params[:id])
    @po_line.destroy

    respond_to do |format|
      format.html { redirect_to po_header_po_lines_url(po_header) }
      format.json { head :ok }
    end
  end
end
