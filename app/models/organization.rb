class Organization < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	attr_accessible :customer_contact_type_id, :customer_max_quality_id, :customer_min_quality_id, 
	:organization_address_1, :organization_address_2, :organization_city, :organization_country, 
	:organization_created_id, :organization_description, :organization_email, :organization_fax, 
	:organization_name, :organization_notes, :organization_short_name, :organization_state, 
	:organization_telephone, :organization_type_id, :organization_updated_id, :organization_website, 
	:organization_zipcode, :vendor_expiration_date, :user_id, :territory_id, :customer_quality_id, 
	:vendor_quality_id, :organization_complete, :organization_active

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

		unless CommonActions.nil_or_blank(self.organization_name) || 
			CommonActions.nil_or_blank(self.organization_short_name) || 
			CommonActions.nil_or_blank(self.organization_description) || 
			CommonActions.nil_or_blank(self.organization_address_1) || 
			CommonActions.nil_or_blank(self.organization_city) || 
			CommonActions.nil_or_blank(self.organization_state) || 
			CommonActions.nil_or_blank(self.organization_zipcode) || 
			CommonActions.nil_or_blank(self.organization_telephone) || 
			CommonActions.nil_or_blank(self.organization_website) || 
			(self.contact_type.type_value == "fax" ? CommonActions.nil_or_blank(self.organization_fax) : CommonActions.nil_or_blank(self.organization_email)) ||
			(self.organization_type.type_value == "customer" ? (self.customer_quality.nil? || self.min_vendor_quality.nil?) : false) || 
			(self.organization_type.type_value == "vendor" ? self.vendor_quality.nil? : false)
				self.organization_complete = true
		else
				self.organization_complete = false
		end

		return true
	end

	validates_presence_of :organization_type

	# validates_presence_of :contact_type

	(validates_uniqueness_of :organization_name if validates_length_of :organization_name, :minimum => 2, :maximum => 50) if validates_presence_of :organization_name

	# (validates_uniqueness_of :organization_short_name if validates_length_of :organization_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :organization_short_name	

	# validates_formatting_of :organization_telephone, :using => :us_phone if validates_presence_of :organization_telephone

	# validates_formatting_of :organization_zipcode, :using => :us_zip if validates_presence_of :organization_zipcode

	validates_formatting_of :organization_email, :using => :email, :if => Proc.new { |o| o.contact_type.present? && o.contact_type.type_value == "email" }

	validates_length_of :organization_fax, in: 10..32, :if => Proc.new { |o| o.contact_type.present? && o.contact_type.type_value == "fax" }

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
	has_many :process_types, :through => :organization_processes
	has_many :gauges, :dependent => :destroy
	has_many :item_revisions
	has_many :po_headers, :dependent => :destroy #For vendor
	has_many :po_lines, :dependent => :destroy #For Customers
	has_many :attachments, :as => :attachable, :dependent => :destroy
	has_many :item_alt_names, :dependent => :destroy
	has_many :so_headers
    has_many :so_lines
    has_many :payables, :dependent => :destroy
    has_many :receivables, :dependent => :destroy
    has_many :quote_vendors, :dependent => :destroy
    has_many :quotes
    has_many :quote_lines

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

  	def sales_orders
  		case(self.organization_type.type_value)
          	when "customer"              	
              	SoHeader.where("organization_id = ?", self.id)
          	when "vendor"
              	SoHeader.joins(:so_lines).where("so_lines.organization_id = ?", self.id)
          	else
              	SoHeader.where("organization_id = ?", 0)
      	end
  	end 	

  	def organization_type_title
  		case(self.organization_type.type_value)
          	when "customer"
              	" With Customer"
          	when "vendor"
              	" With Vendor"
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

  	def contact_type_category(type)
 		"default_" + type + "_of_org_" + self.id.to_s
 	end

 	def default_address
 		type_category = self.contact_type_category("address")
 		MasterType.find_by_type_category(type_category)
 	end

 	def self.find_organization(params)
		if params[:po_id].present?
	        po_header = PoHeader.find(params[:po_id])
	        po_header.organization if po_header
        elsif params[:so_id].present?
	        so_header = SoHeader.find(params[:so_id])
	        so_header.organization if so_header
	    elsif params[:object_id].present?
	    	Organization.find(params[:object_id])
	    else
	    	nil
	    end
 	end



end
