# == Schema Information
#
# Table name: organizations
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  organization_type_id     :integer
#  territory_id             :integer
#  customer_quality_id      :integer
#  customer_contact_type_id :integer
#  customer_max_quality_id  :integer
#  vendor_quality_id        :integer
#  vendor_expiration_date   :date
#  organization_name        :string(255)
#  organization_short_name  :string(255)
#  organization_description :string(255)
#  organization_address_1   :text(65535)
#  organization_address_2   :text(65535)
#  organization_city        :string(255)
#  organization_state       :string(255)
#  organization_country     :string(255)
#  organization_zipcode     :string(255)
#  organization_telephone   :string(255)
#  organization_fax         :string(255)
#  organization_email       :string(255)
#  organization_website     :string(255)
#  organization_notes       :text(65535)
#  organization_active      :boolean
#  organization_created_id  :integer
#  organization_updated_id  :integer
#  created_at               :datetime
#  updated_at               :datetime
#  customer_min_quality_id  :integer
#  organization_complete    :boolean          default(FALSE)


class Organization < ActiveRecord::Base
  acts_as_paranoid
  attr_accessor :organization_expiration_date, :links
  attr_accessor :address_1, :address_2, :city, :country, :state,  :zipcode, :address_type, :address_title

  # belongs_to :user
  belongs_to :territory
  belongs_to :customer_quality
  belongs_to :vendor_quality
  belongs_to :organization_type, -> { where type_category: 'organization_type' },
             class_name: 'MasterType', foreign_key: 'organization_type_id'
  belongs_to :contact_type, -> { where type_category: 'customer_contact_type' },
             class_name: 'MasterType', foreign_key: 'customer_contact_type_id'
  belongs_to :max_vendor_quality,
             class_name: 'VendorQuality',
             foreign_key: 'customer_max_quality_id'
  belongs_to :min_vendor_quality,
             class_name: 'VendorQuality',
             foreign_key: 'customer_min_quality_id'
             
  has_one :notification, as: :notable, dependent: :destroy
  accepts_nested_attributes_for :notification, allow_destroy: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :organization_processes, dependent: :destroy
  has_many :process_types, through: :organization_processes
  has_many :gauges, dependent: :destroy
  has_many :item_revisions
  has_many :po_headers, dependent: :destroy # For vendor
  has_many :po_lines, dependent: :destroy # For Customers
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :item_alt_names, dependent: :destroy
  has_many :so_headers, dependent: :destroy
  has_many :so_lines, dependent: :destroy
  has_many :payables, dependent: :destroy
  has_many :receivables, dependent: :destroy
  has_many :quote_vendors, dependent: :destroy
  has_many :quotes, foreign_key: 'customer_id', dependent: :destroy
  has_many :quote_lines
  has_many :groups, through: :group_organizations
  has_many :group_organizations, dependent: :destroy
  has_many :customer_quotes, dependent: :destroy
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users
  # has_many :quotes, :through => :quotes_organizations
  # has_many :quotes
  # has_many :quotes_organizations

  validates_presence_of :organization_type
  # validates_presence_of :contact_type
  (validates_uniqueness_of :organization_name if validates_length_of :organization_name, minimum: 2, maximum: 50) if validates_presence_of :organization_name
  # (validates_uniqueness_of :organization_short_name if validates_length_of :organization_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :organization_short_name
  # validates_formatting_of :organization_telephone, :using => :us_phone if validates_presence_of :organization_telephone
  # validates_formatting_of :organization_zipcode, :using => :us_zip if validates_presence_of :organization_zipcode
  # validates_formatting_of :organization_email, using: :email, if: proc { |o| (o.contact_type.present? && o.contact_type.type_value == 'email') || o.organization_email.present? }
  validates_length_of :organization_fax, in: 10..32, if: proc { |o| (o.contact_type.present? && o.contact_type.type_value == 'fax') || o.organization_fax.present? }
  validates_length_of :organization_address_1, :organization_address_2, maximum: 150, allow_blank: true
  after_initialize :default_values
  after_create :process_after_create
  before_save :process_before_save

  scope :organizations, lambda { |type|
    case type
    when 'vendor'
      where(organization_type_id: MasterType.find_by_type_value('vendor').id)
    when 'customer'
      where(organization_type_id: MasterType.find_by_type_value('customer').id)
    when 'support'
      where(organization_type_id: MasterType.find_by_type_value('support').id)
      end
  }

  [:address_1, :address_2, :city, :country, :state, :zipcode, :address_type, :address_title].each do |method_name|
    define_method "organization_#{method_name}" do |*value|
      m_name = [:address_type, :address_title].include?(method_name) ? "#{method_name}" : "address_#{method_name}"
      self.default_address.try(:send, m_name.to_sym)
    end
  end

  # scope :vendor_only, where(:organization_type_id => MasterType.find_by_type_value("vendor").id)
  # scope :customer_only, where(:organization_type_id => MasterType.find_by_type_value("customer").id)
  # scope :support_only, where(:organization_type_id => MasterType.find_by_type_value("support").id)

  [:name,:address1,:address2,:fax].each do |method_name|
    define_method "company_#{method_name}" do |*args|
      if [:address1, :address2].include?(method_name)
        m_name = method_name.to_s[0..-2]
        last_char = method_name.to_s[-1]
        m_name = "#{m_name}_#{last_char}"
      else
        m_name = method_name
      end
      self.try(:send, "organization_#{m_name}".to_sym)
    end
  end

  [:logo, :phone1, :company_phone1].each do |method_name|
    define_method "#{method_name}" do |*args|
      return ""
    end
  end
  # Sets active to true by default.
  # TODO: this can be done using the schema file (migration)

  def default_values
    self.organization_active = true if attributes.key?('organization_active') && organization_active.nil?
  end

  # Creates a Contact for the organization with contact_type 'address'
  # The information mirrors the organizational entity.
  def process_after_create
    # Note: Both contacts and addresses fields are same so when organization create then address info will store in Address table so commented the code for contact :- Vishal

    # contact = contacts.build(contact_address_1: organization_address_1, contact_address_2: organization_address_2,
    #                          contact_city: organization_city, contact_country: organization_country, contact_description: organization_description,
    #                          contact_email: organization_email, contact_fax: organization_fax, contact_notes: organization_notes,
    #                          contact_state: organization_state, contact_telephone: organization_telephone, contact_title: organization_name,
    #                          contact_website: organization_website, contact_zipcode: organization_zipcode, contact_type: 'contact')
    # contact.save!

     address = addresses.build(address_address_1: address_1, address_address_2: address_2,
                             address_city: city, address_country: country, address_state: state, address_title: address_title, address_zipcode: zipcode, address_type: 'address')
    address.save
  end

  # Creates a Zipcode Territory if one does not already exist.
  # A zipcode territory is the first 2 digits of the zipcode for the firm.
  # It then assigns the organization to the territory
  # It then checks all the fields, if any are blank, it registers as an
  # incomplete profile.
  def process_before_save
    zipcode = organization_zipcode.split('')[0..1].join('') if organization_zipcode.present?
    teriitory = Territory.find_by_territory_identifier(zipcode)
    unless teriitory
      teriitory = Territory.new(territory_identifier: zipcode)
      teriitory.save
    end
    self.territory = teriitory

    if CommonActions.nil_or_blank(organization_name) ||
       CommonActions.nil_or_blank(organization_short_name) ||
       CommonActions.nil_or_blank(organization_description) ||
       CommonActions.nil_or_blank(organization_address_1) ||
       CommonActions.nil_or_blank(organization_city) ||
       CommonActions.nil_or_blank(organization_state) ||
       CommonActions.nil_or_blank(organization_zipcode) ||
       CommonActions.nil_or_blank(organization_telephone) ||
       CommonActions.nil_or_blank(organization_website) ||
       (contact_type.type_value == 'fax' ? CommonActions.nil_or_blank(organization_fax) : CommonActions.nil_or_blank(organization_email)) ||
       (organization_type.type_value == 'customer' ? (customer_quality.nil? || min_vendor_quality.nil?) : false) ||
       (organization_type.type_value == 'vendor' ? vendor_quality.nil? : false)
      self.organization_complete = false
    else
      self.organization_complete = true
    end
    true
  end

  # TODO: this can be done using the controller respond_with
  def redirect_path
    organization_path(self)
  end

  # If the organization is a customer, it gives us all Chess POs where po_lines
  # have the customer as the organization called on.
  # When a vendor, it shows all PO headers that were made to that vendor
  def purchase_orders
    case organization_type.type_value
    when 'customer'
      PoHeader.joins(:po_lines).where('po_lines.organization_id = ?', id).order('created_at desc')
    when 'vendor'
      PoHeader.where('organization_id = ?', id).order('created_at desc')
    else
      PoHeader.where('organization_id = ?', 0).order('created_at desc')
      end
  end

  # If the organization is a customer, it gives us all Chess SO to the customer
  # If the organization is a vendor, it shows all SO_lines where the vendor was
  # added as the supplier.
  # TODO: have this backfilled after the lot is chosen. Once a lot is shipped,
  # we know the supplier. By filling this in, we can find all so_line item
  # vendors, not just the ones that are entered manually.
  def sales_orders
    case organization_type.type_value
    when 'customer'
      SoHeader.where('organization_id = ?', id).order('created_at desc')
    when 'vendor'
      SoHeader.joins(:so_lines).where('so_lines.organization_id = ?', id).order('created_at desc')
    else
      SoHeader.where('organization_id = ?', 0).order('created_at desc')
      end
  end

  # Text transformation for Table headings
  def organization_type_title
    if organization_name
      ' Associated With ' + organization_name
    else
      ''
    end
  end

  # All po line items which have a PO header to them (vendor only)
  # used for listing vendor items
  def po_items
    # po_items = self.po_headers.joins(:po_lines).select("po_lines.item_id").where("po_headers.organization_id = ?",self.id).order("po_lines.created_at DESC")
    po_items = PoLine.includes(:po_header).where('po_headers.organization_id = ?', id).order('po_headers.created_at DESC')
    po_items = po_items.collect(& :item_id)
    Item.where(id: po_items)
  end

  # All so line items which have a sales order written to them (customer only)
  # used for listing all customer items.
  def so_items
    # so_items = self.so_headers.joins(:so_lines).select("so_lines.item_id").where("so_headers.organization_id = ?",self.id).order("so_lines.created_at DESC")
    so_items = SoLine.includes(:so_header).where('so_headers.organization_id = ?', id).order('so_headers.created_at DESC')
    so_items = so_items.collect(& :item_id)
    Item.where(id: so_items)
  end

  def type_name
    organization_type.type_value
  end

  # Text transformation
  # ex. 'default_address_of_org_1'
  # Used to set the default_address below
  def contact_type_category(type)
    'default_' + type + '_of_org_' + id.to_s
  end

  # When an address is set as default, a type_category matching the comments
  # in the method contact_type_category is created in the mastertype table.
  # The below method creates the string using the contact_type_category method
  # And then searches for it returning the default address (probably uses the
  # contact id under the attribute type_value.)
  # TODO: this can probably be written differently. A default address join table?
  def default_address
    self.addresses.where(address_type: 'default').first || self.addresses.first
    # type_category = contact_type_category('address')
    # MasterType.find_by_type_category(type_category)
  end

  # retrieve an organization from po_id, so_id, or object_id
  def self.find_organization(params)
    if params[:po_id].present?
      po_header = PoHeader.find(params[:po_id])
      po_header.organization if po_header
    elsif params[:so_id].present?
      so_header = SoHeader.find(params[:so_id])
      so_header.organization if so_header
    elsif params[:object_id].present?
      Organization.find(params[:object_id])
      end
  end
end
