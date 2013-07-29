class ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.json
  def index  
    @contact_type = params[:contact_type] || "address"
    @contactable = Organization.find_by_id(params[:object_id])
    @contacts = @contactable.contacts.where(:contact_type => @contact_type)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
            @contacts = @contacts.select{|contact| 
            contact[:links] = CommonActions.object_crud_paths(contact_path(contact), edit_contact_path(contact), nil)
            }
            render json: {:aaData => @contacts}        
      }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])
    @contactable = @contact.contactable

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contactable = Organization.find_by_id(params[:object_id])
    if @contactable
        @contact = Contact.new
        @contact.contact_type = params[:contact_type] || "address"
        @contact.contactable_id = @contactable.id
        @contact.contactable_type = @contactable.class

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @contact }
        end
    else
        redirect_to organizations_path
    end
  end

  # GET /contacts/1/edit
  def edit     
    @contact = Contact.find(params[:id])
    @contactable = @contact.contactable
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(params[:contact])
    @contactable = @contact.contactable

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: @contact.contact_type.titlecase + ' was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])
    @contactable = @contact.contactable

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: @contact.contact_type.titlecase + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contactable = @contact.contactable
    @contact_type = @contact.contact_type || "address"
    @contact.destroy

    respond_to do |format|
      format.html { 
        case(params[:redirect_to])
            when "index"
                redirect_to contacts_path(:object_id => @contactable.id, :contact_type => @contact_type)
            else
                redirect_to request.referrer
        end
      }
      format.json { head :no_content }
    end
  end
end
