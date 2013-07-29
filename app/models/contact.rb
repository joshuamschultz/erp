class Contact < ActiveRecord::Base
  attr_accessible :contact_active, :contact_address_1, :contact_address_2, :contact_city, 
  :contact_country, :contact_created_id, :contact_description, :contact_email, :contact_fax, 
  :contact_notes, :contact_state, :contact_telephone, :contact_title, :contact_updated_id, 
  :contact_website, :contact_zipcode, :contactable_id, :contactable_type, :contact_type,
  :first_name, :last_name

	after_initialize :default_values

	def default_values
		self.contact_active = true if self.contact_active.nil?
	end

	validates_presence_of :contactable

	validates_length_of :contact_title, :minimum => 2, :maximum => 20 if validates_presence_of :contact_title	

	# validates_formatting_of :contact_telephone, :using => :us_phone if validates_presence_of :contact_telephone

	# validates_formatting_of :contact_zipcode, :using => :us_zip if validates_presence_of :contact_zipcode

	# validates_formatting_of :contact_email, :using => :email if validates_presence_of :contact_email

	validates_formatting_of :contact_telephone, :using => :us_phone, :unless => Proc.new { |o| o.contact_telephone == "" }

	validates_formatting_of :contact_zipcode, :using => :us_zip, :unless => Proc.new { |o| o.contact_zipcode == "" }

	validates_formatting_of :contact_email, :using => :email, :unless => Proc.new { |o| o.contact_email == "" }  	

  	validate :contact_fields

  	def contact_fields
  		if self.contact_type == "contact"
  			validates_length_of :first_name, :minimum => 2, :maximum => 20 if validates_presence_of :first_name
  			validates_length_of :last_name, :minimum => 2, :maximum => 20 if validates_presence_of :last_name
  		end
  	end

 	# contact_type - address/contact

 	belongs_to :contactable, :polymorphic => true
end
