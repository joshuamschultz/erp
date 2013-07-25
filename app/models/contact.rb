class Contact < ActiveRecord::Base
  attr_accessible :contact_active, :contact_address_1, :contact_address_2, :contact_city, 
  :contact_country, :contact_created_id, :contact_description, :contact_email, :contact_fax, 
  :contact_notes, :contact_state, :contact_telephone, :contact_title, :contact_updated_id, 
  :contact_website, :contact_zipcode, :contactable_id, :contactable_type, :contact_type

  belongs_to :contactable, :polymorphic => true

  # contact_type - address/contact
end
