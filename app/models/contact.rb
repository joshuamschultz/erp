class Contact < ActiveRecord::Base
  attr_accessible :contact_active, :contact_address_1, :contact_address_2, :contact_city, 
  :contact_country, :contact_created_id, :contact_description, :contact_email, :contact_fax, 
  :contact_notes, :contact_state, :contact_telephone, :contact_title, :contact_updated_id, 
  :contact_website, :contact_zipcode, :contactable_id, :contactable_type, :contact_type

	# validates_presence_of :contactable

	# validates_length_of :contact_title, :minimum => 2, :maximum => 20 if validates_presence_of :contact_title	

	# validates_formatting_of :contact_telephone, :using => :us_phone if validates_presence_of :contact_telephone

	# validates_formatting_of :contact_zipcode, :using => :us_zip if validates_presence_of :contact_zipcode

	# validates_formatting_of :contact_email, :using => :email if validates_presence_of :contact_email


  	belongs_to :contactable, :polymorphic => true

  	# contact_type - address/contact
end
