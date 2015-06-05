class ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.json

  before_filter :set_page_info

  before_filter :view_permissions, except: [:index, :show]
  before_filter :user_permissions


  def view_permissions
   if  user_signed_in? && current_user.is_logistics?
        authorize! :edit, Contact
    end
  end

  def user_permissions
   if  user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
        authorize! :edit, Contact
    end
  end

  def set_page_info
    unless user_signed_in? && ( current_user.is_vendor? || current_user.is_customer? )
      @menus[:contacts][:active] = "active"
    end
  end


  def index
    @contact_type = params[:contact_type] || "address"
    @contactable = Organization.find_organization(params)

    if @contactable
        p  @contacts = @contactable.contacts.where(:contact_type => @contact_type)
    else
        if params[:org_type]
        @org_type = MasterType.find_by_type_value(params[:org_type] ||= "vendor")

        @organizations = @org_type.type_based_organizations
        @contacts = Contact.where(:contact_type => @contact_type, :contactable_id => @organizations.collect(&:id), :contactable_type => "Organization")
        else
          @contacts = Contact.all
        end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {
          @contacts = @contacts.select{|contact|
            contact[:organization] = CommonActions.linkable(organization_path(contact.contactable), "Organization : " + contact.contactable.organization_short_name)
            contact[:first_name] = CommonActions.linkable(contact_path(contact), contact[:first_name]) if @contact_type == "contact"
            contact[:contact_name] = contact.contact_title
            contact[:contact_default] = contact.default_address.present? ? "selected" : ""
            contact[:contact_title] = CommonActions.linkable(contact_path(contact), contact[:contact_title]) if @contact_type == "address"
            if can? :edit, Contact
              contact[:links] = CommonActions.object_crud_paths(nil, edit_contact_path(contact), nil)
            else
               contact[:links] = ""
            end
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
        format.html { redirect_to @contactable, notice: @contact.contact_type.titlecase + ' was successfully created.' }
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
        format.html { redirect_to @contactable, notice: @contact.contact_type.titlecase + ' was successfully updated.' }
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

  def set_default
    @contact = Contact.find(params[:contact_id])
    @contactable = @contact.contactable

    respond_to do |format|
      if @contact && @contactable
          type_category = @contactable.contact_type_category("address")
          MasterType.where(:type_category => type_category).destroy_all
          MasterType.create(:type_name => "Default Organization Contact/Address", :type_description => "", :type_value => @contact.id, :type_category => type_category, :type_active => true)
      end
      format.html { redirect_to @contact, notice: 'Address was successfully added as default.' }
      format.json { head :no_content }
    end
  end


end
