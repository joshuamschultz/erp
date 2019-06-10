class AddressesController < ApplicationController
  before_action :view_permissions, except: %i[index show]
  before_action :user_permissions
  before_action :set_address, only: %i[show edit update destroy]

  def view_permissions
    authorize! :edit, Address if user_signed_in? && current_user.is_logistics?
  end

  def user_permissions
    if user_signed_in? && (current_user.is_vendor? || current_user.is_customer?)
      authorize! :edit, Address
    end
  end

  def new
    @addressable = Organization.find_by_id(params[:object_id])
    if @addressable
      @address = Address.new
      @address.address_type = params[:address_type] || 'address'
      @address.addressable_id = @addressable.id
      @address.addressable_type = @addressable.class
      respond_with @address
    else
      redirect_to organizations_path
    end
  end

  def create
    @address = Address.new(address_params)
    @addressable = @address.addressable
    @address.save
    respond_with @addressable
  end

  def index
    @address_type = 'address'
    @addressable = Organization.find_organization(params)

    if @addressable
      @addresses = @addressable.addresses.where(address_type: @address_type)
    else
      if params[:org_type]
        @org_type = MasterType.find_by_type_value(params[:org_type] ||= 'vendor')

        @organizations = @org_type.type_based_organizations
        @addresses = Address.where(address_type: @address_type, addressable_id: @organizations.collect(&:id), addressable_type: 'Organization')
      else
        @addresses = Address.all
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      @addss = []
      format.json do
        @addresses = @addresses.select do |address|
          adds = {}
          address.attributes.each do |key, value|
            adds[key] = value
          end
          if address.addressable.organization_short_name.blank?
            org_name = address.addressable.organization_name
          else
            org_name = address.addressable.organization_short_name
          end
          adds[:organization] = CommonActions.linkable(organization_path(address.addressable), 'Organization : ' + org_name)
          adds[:address_name] = address.address_title
          adds[:address_default] = address.default_address.present? ? 'selected' : ''
          adds[:address_title] = CommonActions.linkable(address_path(address), address[:address_title]) if @address_type == 'address'
          adds[:address_email] = "<a href='mailto:#{address.address_email}' target='_top'>#{address.address_email}</a>"

          if can? :edit, Address
            adds[:links] = CommonActions.object_crud_paths(nil, edit_address_path(address), nil)
          else
            adds[:links] = ''
          end
          @addss.push(adds)
        end
        render json: { aaData: @addss }
      end
    end
  end

  def edit
    @referrer = request.controller_class
  end

  def update
    @address.update(address_params)
    @address.save
    respond_with @addressable
  end

  def destroy
    @address_type = @address.address_type || 'address'
    @referrer = params[:referrer]
    @address.destroy
    redirect_to @addressable
  end

  def show; end

  private

  def set_address
    @address = Address.find(params[:id])
    @addressable = @address.addressable
  end

  def address_params
    params.require(:address).permit(:address_active, :address_address_1, :address_address_2, :address_city,
                                    :address_country, :address_created_id, :address_description, :address_email, :address_fax,
                                    :address_notes, :address_state, :address_telephone, :address_title, :address_updated_id,
                                    :address_website, :address_zipcode, :addressable_id, :addressable_type, :address_type)
  end
end
