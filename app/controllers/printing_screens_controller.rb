class PrintingScreensController < ApplicationController
  # GET /printing_screens
  # GET /printing_screens.json
  def index
    @printing_screens = PrintingScreen.all

    respond_to do |format|
      format.html # index.html.erb
      format.json {
       @printing_screens = @printing_screens.select{|printing_screen|

              printing_screen[:ids] = CommonActions.linkable(printing_screen_path(printing_screen), printing_screen.id)
              printing_screen[:status] = printing_screen.status
              printing_screen[:payment_name] = printing_screen.payment.present? ? CommonActions.linkable(payment_path(printing_screen.payment), printing_screen.payment_id) : ""

              printing_screen[:links] = CommonActions.object_crud_paths(nil, edit_printing_screen_path(printing_screen), nil)
              printing_screen[:print_check] = CommonActions.linkable(printing_screens_path,  "Print Check" )


        }
        render json: {:aaData => @printing_screens}
      }
    end
  end

  # GET /printing_screens/1
  # GET /printing_screens/1.json
  def show
    @printing_screen = PrintingScreen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @printing_screen }
    end
  end

  # GET /printing_screens/new
  # GET /printing_screens/new.json
  def new
    @printing_screen = PrintingScreen.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @printing_screen }
    end
  end

  # GET /printing_screens/1/edit
  def edit
    @printing_screen = PrintingScreen.find(params[:id])
  end

  # POST /printing_screens
  # POST /printing_screens.json
  def create
    @printing_screen = PrintingScreen.new(printing_screen_params)

    respond_to do |format|
      if @printing_screen.save
        format.html { redirect_to @printing_screen, notice: 'Printing screen was successfully created.' }
        format.json { render json: @printing_screen, status: :created, location: @printing_screen }
      else
        format.html { render action: "new" }
        format.json { render json: @printing_screen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /printing_screens/1
  # PUT /printing_screens/1.json
  def update
    @printing_screen = PrintingScreen.find(params[:id])

    respond_to do |format|
      if @printing_screen.update_attributes(printing_screen_params)
        format.html { redirect_to @printing_screen, notice: 'Printing screen was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @printing_screen.errors, status: :unprocessable_entity }
      end
      if @printing_screen.status == "closed"
        reconcile = Reconcile.find_by_printing_screen_id(@printing_screen.id)
        reconcile.update_attribute(:tag, "not reconciled")
      end
    end
  end

  # DELETE /printing_screens/1
  # DELETE /printing_screens/1.json
  def destroy
    @printing_screen = PrintingScreen.find(params[:id])
    @printing_screen.destroy

    respond_to do |format|
      format.html { redirect_to printing_screens_url }
      format.json { head :no_content }
    end
  end
  private

    def set_printing_screen
      @printing_screen = PrintingScreen.find(params[:id])
    end

    def printing_screen_params
      params.require(:printing_screen).permit(:status, :payment_id)
    end
end
