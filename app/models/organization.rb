class Organization < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	attr_accessible :customer_contact_type_id, :customer_max_quality_id, :customer_min_quality_id, :organization_active, 
	:organization_address_1, :organization_address_2, :organization_city, :organization_country, 
	:organization_created_id, :organization_description, :organization_email, :organization_fax, 
	:organization_name, :organization_notes, :organization_short_name, :organization_state, 
	:organization_telephone, :organization_type_id, :organization_updated_id, :organization_website, 
	:organization_zipcode, :vendor_expiration_date, :user_id, :territory_id, :customer_quality_id, 
	:vendor_quality_id

	scope :organizations, lambda{|type| 
		case(type)
			when "vendor"
				where(:organization_type_id => MasterType.find_by_type_value("vendor").id)
			when "customer"
				where(:organization_type_id => MasterType.find_by_type_value("customer").id)
			when "support"
				where(:organization_type_id => MasterType.find_by_type_value("support").id)
		end
	}

	# scope :vendor_only, where(:organization_type_id => MasterType.find_by_type_value("vendor").id)

	# scope :customer_only, where(:organization_type_id => MasterType.find_by_type_value("customer").id)

	# scope :support_only, where(:organization_type_id => MasterType.find_by_type_value("support").id)

	after_initialize :default_values	

	def default_values
		self.organization_active = true if self.attributes.has_key?("organization_active") && self.organization_active.nil?
	end

	before_save :process_before_save

	def process_before_save
		zipcode = self.organization_zipcode.split("")[0..1].join("") if self.organization_zipcode.present?
		teriitory = Territory.find_by_territory_identifier(zipcode)
		unless teriitory
			teriitory = Territory.new(:territory_identifier => zipcode)
			teriitory.save
		end
		self.territory = teriitory
	end

	validates_presence_of :organization_type

	(validates_uniqueness_of :organization_name if validates_length_of :organization_name, :minimum => 2, :maximum => 50) if validates_presence_of :organization_name

	(validates_uniqueness_of :organization_short_name if validates_length_of :organization_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :organization_short_name	

	validates_formatting_of :organization_telephone, :using => :us_phone if validates_presence_of :organization_telephone

	validates_formatting_of :organization_zipcode, :using => :us_zip if validates_presence_of :organization_zipcode

	validates_formatting_of :organization_email, :using => :email, :if => Proc.new { |o| o.contact_type.type_value == "email" }

	validates_length_of :organization_fax, in: 10..32, :if => Proc.new { |o| o.contact_type.type_value == "fax" }

	belongs_to :user
	belongs_to :territory
	belongs_to :customer_quality
	belongs_to :vendor_quality

  	belongs_to :organization_type, :class_name => "MasterType", :foreign_key => "organization_type_id", 
  	:conditions => ['type_category = ?', 'organization_type']

	belongs_to :contact_type, :class_name => "MasterType", :foreign_key => "customer_contact_type_id", 
	:conditions => ['type_category = ?', 'customer_contact_type']

	belongs_to :max_vendor_quality, :class_name => "VendorQuality", :foreign_key => "customer_max_quality_id"

	belongs_to :min_vendor_quality, :class_name => "VendorQuality", :foreign_key => "customer_min_quality_id"

	has_many :comments, :as => :commentable, :dependent => :destroy
	has_many :contacts, :as => :contactable, :dependent => :destroy
	has_many :organization_processes, :dependent => :destroy
	has_many :gauges, :dependent => :destroy
	has_many :item_revisions
	has_many :po_headers, :dependent => :destroy #For vendor
	has_many :po_lines, :dependent => :destroy #For Customers
	has_many :attachments, :as => :attachable, :dependent => :destroy

	def redirect_path
      	organization_path(self)
  	end

  	def purchase_orders
  		case(self.organization_type.type_value)
          	when "customer"
              	PoHeader.joins(:po_lines).where("po_lines.organization_id = ?", self.id)
          	when "vendor"
              	PoHeader.where("organization_id = ?", self.id)
          	else
              	PoHeader.where("organization_id = ?", 0)
      	end
  	end 	

  	def purchase_order_title
  		case(self.organization_type.type_value)
          	when "customer"
              	" For Customer"
          	when "vendor"
              	" From Vendor"
          	else
              	""
      	end
  	end

  	def items_with_recent_revision
  		Item.item_with_recent_revisions.where("item_revisions.organization_id = ?", self.id)
  	end

  	def type_name
  		self.organization_type.type_value
  	end

end
