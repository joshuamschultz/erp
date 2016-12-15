class ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.json

  before_action :set_page_info

  before_action :view_permissions, except: [:index, :show]
  before_action :user_permissions


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
       @concts = Array.new
      format.json {
          @contacts = @contacts.select{|contact|
            conct = Hash.new
            contact.attributes.each do |key, value|
              conct[key] = value
            end
            conct[:organization] = CommonActions.linkable(organization_path(contact.contactable), "Organization : " + contact.contactable.organization_short_name)
            conct[:first_name] = CommonActions.linkable(contact_path(contact), contact[:first_name]) if @contact_type == "contact"
            conct[:contact_name] = contact.contact_title
            conct[:contact_default] = contact.default_address.present? ? "selected" : ""
            conct[:contact_title] = CommonActions.linkable(contact_path(contact), contact[:contact_title]) if @contact_type == "address"
            conct[:contact_email] = "<a href='mailto:#{contact.contact_email}' target='_top'>#{contact.contact_email.to_s}</a>"

            if can? :edit, Contact
              conct[:links] = CommonActions.object_crud_paths(nil, edit_contact_path(contact), nil)
            else
               conct[:links] = ""
            end
            @concts.push(conct)
          }
          render json: {:aaData => @concts}
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
    @contact = Contact.new(contact_params)
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
      if @contact.update_attributes(contact_params)
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
  private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:contact_active, :contact_address_1, :contact_address_2, :contact_city,
      :contact_country, :contact_created_id, :contact_description, :contact_email, :contact_fax,
      :contact_notes, :contact_state, :contact_telephone, :contact_title, :contact_updated_id,
      :contact_website, :contact_zipcode, :contactable_id, :contactable_type, :contact_type,
      :first_name, :last_name)
    end
end
