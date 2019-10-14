# == Schema Information
#
# Table name: contacts
#
#  id                  :integer          not null, primary key
#  contactable_id      :integer
#  contactable_type    :string(255)
#  contact_type        :string(255)
#  contact_title       :string(255)
#  contact_description :string(255)
#  contact_address_1   :text(65535)
#  contact_address_2   :text(65535)
#  contact_city        :string(255)
#  contact_state       :string(255)
#  contact_country     :string(255)
#  contact_zipcode     :string(255)
#  contact_telephone   :string(255)
#  contact_fax         :string(255)
#  contact_email       :string(255)
#  contact_website     :string(255)
#  contact_notes       :text(65535)
#  contact_active      :boolean
#  contact_created_id  :integer
#  contact_updated_id  :integer
#  created_at          :datetime
#  updated_at          :datetime
#  first_name          :string(255)
#  last_name           :string(255)
#

class Contact < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  has_many :billed_so_orders, class_name: 'SoHeader', foreign_key: 'so_bill_to_id'
  has_many :shipped_so_orders, class_name: 'SoHeader', foreign_key: 'so_ship_to_id'
  has_many :payables, class_name: 'Payable', foreign_key: 'payable_to_id'

  has_many :addresses, as: :addressable, dependent: :destroy
  after_initialize :default_values

  validates_presence_of :contactable
  validates_length_of :contact_title, minimum: 2, maximum: 20 if validates_presence_of :contact_title
  validates_length_of :contact_description, minimum: 2, maximum: 100 if validates_presence_of :contact_description
  # validates_formatting_of :contact_telephone, :using => :us_phone if validates_presence_of :contact_telephone
  # validates_formatting_of :contact_zipcode, :using => :us_zip if validates_presence_of :contact_zipcode
  # validates_formatting_of :contact_email, :using => :email if validates_presence_of :contact_email
  validates_formatting_of :contact_telephone, using: :us_phone, unless: proc { |o| o.contact_telephone == '' }
  # validates_formatting_of :address_zipcode, using: :us_zip, unless: proc { |o| o.address_zipcode == '' }
  validates_formatting_of :contact_email, using: :email, unless: proc { |o| o.contact_email == '' }
  validate :contact_fields
  before_create :add_address

  #remove these columns later
  attr_accessor :address_1, :address_2, :city, :country, :state,  :zipcode, :address_type, :address_title

  # custom validation used above

  # getter methods for these columns
  # later remove these columns

  [:address_1, :address_2, :city, :country, :state, :zipcode, :address_type, :address_title].each do |method_name|
    define_method "contact_#{method_name}" do |*value|
      m_name = [:address_type, :address_title].include?(method_name) ? "#{method_name}" : "address_#{method_name}"
      # m_name = "address_#{method_name}"
      self.default_address.try(:send, m_name.to_sym)
    end
  end

  def contact_fields
    if contact_type == 'contact'
      validates_length_of :first_name, minimum: 2, maximum: 20 if validates_presence_of :first_name
      validates_length_of :last_name, minimum: 2, maximum: 20 if validates_presence_of :last_name
    end
   end

  # TODO: do this a with a migration
  def default_values
    self.contact_active = true if contact_active.nil?
  end

  # calls the default address for the organization to which the object belongs
  # So if you have an address for welch allyn, this will call the default for
  # Welch Allyn

  def default_address
    self.addresses.where(address_type: 'default').first
    # type_category = contactable.contact_type_category('address')

    # MasterType.find_by_type_category_and_type_value(type_category, id)
    # false
  end
  private
  def add_address
     address = addresses.build(address_address_1: address_1, address_address_2: address_2,
                             address_city: city, address_country: country,
                             address_state: state,  address_title: address_title,
                             address_zipcode: zipcode, address_type: address_type)
    address.save
  end
end
