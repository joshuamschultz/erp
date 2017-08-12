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
  attr_accessible :contact_active, :contact_address_1, :contact_address_2, :contact_city,
                  :contact_country, :contact_created_id, :contact_description, :contact_email, :contact_fax,
                  :contact_notes, :contact_state, :contact_telephone, :contact_title, :contact_updated_id,
                  :contact_website, :contact_zipcode, :contactable_id, :contactable_type, :contact_type,
                  :first_name, :last_name

  belongs_to :contactable, polymorphic: true
  has_many :billed_so_orders, class_name: 'SoHeader', foreign_key: 'so_bill_to_id'
  has_many :shipped_so_orders, class_name: 'SoHeader', foreign_key: 'so_ship_to_id'
  has_many :payables, class_name: 'Payable', foreign_key: 'payable_to_id'

  after_initialize :default_values

  validates_presence_of :contactable
  validates_length_of :contact_title, minimum: 2, maximum: 20 if validates_presence_of :contact_title
  validates_length_of :contact_description, minimum: 2, maximum: 100 if validates_presence_of :contact_description
  # validates_formatting_of :contact_telephone, :using => :us_phone if validates_presence_of :contact_telephone
  # validates_formatting_of :contact_zipcode, :using => :us_zip if validates_presence_of :contact_zipcode
  # validates_formatting_of :contact_email, :using => :email if validates_presence_of :contact_email
  validates_formatting_of :contact_telephone, using: :us_phone, unless: proc { |o| o.contact_telephone == '' }
  validates_formatting_of :contact_zipcode, using: :us_zip, unless: proc { |o| o.contact_zipcode == '' }
  validates_formatting_of :contact_email, using: :email, unless: proc { |o| o.contact_email == '' }
  validate :contact_fields

  # custom validation used above
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
    type_category = contactable.contact_type_category('address')

    MasterType.find_by_type_category_and_type_value(type_category, id)
  end
end
