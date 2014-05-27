class ReconcilesController < ApplicationController
  # GET /reconciles
  # GET /reconciles.json
  def index
    @reconciles = Reconcile.where(:tag => "not reconciled")

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @reconciles }
        format.json { 
           @reconciles = @reconciles.select{|reconcile|
              reconcile[:id] = CommonActions.linkable(reconcile_path(reconcile.id), reconcile.id)
              reconcile[:tag] = reconcile.tag 
              reconcile[:reconcile_type] = reconcile.reconcile_type
              #reconcile[:payment_id] = reconcile.payment_id              
              reconcile[:payment_id] = CommonActions.linkable(payment_path(reconcile.payment_id), reconcile.payment.payment_identifier) if reconcile.payment_id
              reconcile[:deposit_check_id] = reconcile.deposit_check_id
              reconcile[:printing_screen_id] =reconcile.printing_screen_id
              reconcile[:links] = CommonActions.object_crud_paths(nil, edit_reconcile_path(reconcile), nil)
          }
          render json: {:aaData => @reconciles}
      }
    end
  end

  # GET /reconciles/1
  # GET /reconciles/1.json
  def show
    @reconcile = Reconcile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reconcile }
    end
  end

  # GET /reconciles/new
  # GET /reconciles/new.json
  def new
    @reconcile = Reconcile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reconcile }
    end
  end

  # GET /reconciles/1/edit
  def edit
    @reconcile = Reconcile.find(params[:id])
  end

  # POST /reconciles
  # POST /reconciles.json
  def create
    @reconcile = Reconcile.new(params[:reconcile])

    respond_to do |format|
      if @reconcile.save
        format.html { redirect_to @reconcile, notice: 'Reconcile was successfully created.' }
        format.json { render json: @reconcile, status: :created, location: @reconcile }
      else
        format.html { render action: "new" }
        format.json { render json: @reconcile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reconciles/1
  # PUT /reconciles/1.json
  def update
    @reconcile = Reconcile.find(params[:id])

    respond_to do |format|
      if @reconcile.update_attributes(params[:reconcile])
        format.html { redirect_to @reconcile, notice: 'Reconcile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reconcile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reconciles/1
  # DELETE /reconciles/1.json
  def destroy
    @reconcile = Reconcile.find(params[:id])
    @reconcile.destroy

    respond_to do |format|
      format.html { redirect_to reconciles_url }
      format.json { head :no_content }
    end
  end
end