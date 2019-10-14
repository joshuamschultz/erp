# == Schema Information
#
# Table name: addresses
#
#  id                  :integer          not null, primary key
#  addressable_id      :integer
#  addressable_type    :string(255)
#  address_type        :string(255)
#  address_title       :string(255)
#  address_description :string(255)
#  address_address_1   :text(65535)
#  address_address_2   :text(65535)
#  address_city        :string(255)
#  address_state       :string(255)
#  address_country     :string(255)
#  address_zipcode     :string(255)
#  address_telephone   :string(255)
#  address_fax         :string(255)
#  address_email       :string(255)
#  address_website     :string(255)
#  address_notes       :text(65535)
#  address_active      :boolean
#  address_created_id  :integer
#  address_updated_id  :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Address < ActiveRecord::Base
  attr_accessor :default
  belongs_to :addressable, polymorphic: true
  has_many :billed_so_orders, class_name: 'SoHeader', foreign_key: 'so_bill_to_id'
  has_many :shipped_so_orders, class_name: 'SoHeader', foreign_key: 'so_ship_to_id'
  has_many :payables, class_name: 'Payable', foreign_key: 'payable_to_id'
  after_create :update_default
  # has_one :contact, through: :addressable
  # after_initialize :default_values

  # validates_presence_of :addressable
  # validates_length_of :contact_title, minimum: 2, maximum: 20 if validates_presence_of :contact_title
  # validates_length_of :contact_description, minimum: 2, maximum: 100 if validates_presence_of :contact_description
  # # validates_formatting_of :contact_telephone, :using => :us_phone if validates_presence_of :contact_telephone
  # # validates_formatting_of :contact_zipcode, :using => :us_zip if validates_presence_of :contact_zipcode
  # # validates_formatting_of :contact_email, :using => :email if validates_presence_of :contact_email
  # validates_formatting_of :contact_telephone, using: :us_phone, unless: proc { |o| o.contact_telephone == '' }
  # validates_formatting_of :contact_zipcode, using: :us_zip, unless: proc { |o| o.contact_zipcode == '' }
  # validates_formatting_of :contact_email, using: :email, unless: proc { |o| o.contact_email == '' }
  # validate :contact_fields

  # custom validation used above
  # def contact_fields
  #   if contact_type == 'contact'
  #     validates_length_of :first_name, minimum: 2, maximum: 20 if validates_presence_of :first_name
  #     validates_length_of :last_name, minimum: 2, maximum: 20 if validates_presence_of :last_name
  #   end
  #  end

  # # TODO: do this a with a migration
  # def default_values
  #   self.contact_active = true if contact_active.nil?
  # end

  # # calls the default address for the organization to which the object belongs
  # # So if you have an address for welch allyn, this will call the default for
  # # Welch Allyn
  # def default_address
  #   type_category = contactable.contact_type_category('address')

  #   MasterType.find_by_type_category_and_type_value(type_category, id)
  # end

  def default_address
    type_category = addressable.contact_type_category('address')
    MasterType.find_by_type_category_and_type_value(type_category, id)
  end

  private

  # make sure only one default address exists
  def update_default
    addressable_obj = self.addressable
    default_exists = addressable_obj.addresses.where(address_type: 'default').exists?
    if self.address_type == 'default' || !default_exists
      all_addresses = addressable_obj.addresses.where('id <> ?', self.id)
      all_addresses.update_all(address_type: 'address')
    end
    unless default_exists
      update_column(:address_type, 'default')
    end
  end
end
