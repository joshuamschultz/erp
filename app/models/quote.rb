class Quote < ActiveRecord::Base
  has_many :quote_vendors, :dependent => :destroy
  has_many :quote_lines, :dependent => :destroy
  has_many :quote_line_costs, :through => :quote_lines

  attr_accessible :quote_active, :quote_created_id, :quote_description, :quote_identifier, 
  :quote_notes, :quote_status, :quote_total, :quote_updated_id, :organization_id, :po_header_id, :quote_po_type

  attr_accessor :quote_po_type

  belongs_to :organization
  belongs_to :po_header

  validates_presence_of :quote_description

 def self.process_quote_associations(quote, params)
   	if quote
   		vendors = params[:vendors] || []
    		quote.quote_vendors.where(:organization_id != vendors).destroy_all

    		if vendors
  	      	vendors.each do |vendor_id|
        				unless quote.quote_vendors.find_by_organization_id(vendor_id)
        					  quote_vendor = quote.quote_vendors.new(:organization_id => vendor_id)
                    if quote_vendor.save
                        quote_vendor.process_quote_line_costs
                    end
        				end
  	      	end
  	    end
   	end
 end

 validate :check_quote_vendor, on: :update

 def check_quote_vendor
    unless self.quote_po_type.nil?
        errors.add(:organization_id, "can't be blank") unless self.organization

        if self.quote_po_type == "existing_po"
            errors.add(:po_header_id, "can't be blank") unless self.po_header
        else
            self.po_header = nil
        end
    end
 end

 def vendors
    Organization.where(:id => self.quote_vendors.map(&:organization_id))
 end

 before_create :process_before_create

 def process_before_create
    self.quote_identifier = CommonActions.get_new_identifier(Quote, :quote_identifier)
 end

 before_save :process_before_save

 def process_before_save
    if self.organization.present?
        po_header = self.po_header
        unless po_header.present?
            po_header = PoHeader.new(po_type_id: MasterType.po_types.first.id, organization_id: self.organization_id)
            if po_header.save
                self.po_header = po_header
            end
        end

        if po_header.present?
            self.quote_lines.each do |line|
                quote_vendor = self.quote_vendors.find_by_organization_id(self.organization_id)
                if line.po_line.nil? && quote_vendor.present?
                    quote_line_cost = quote_vendor.quote_line_costs.find_by_quote_line_id(line.id)
                    po_line = po_header.po_lines.new
                    po_line.item_alt_name = line.item_alt_name
                    po_line.po_line_quantity = line.quote_line_quantity
                    po_line.po_line_cost = quote_line_cost.present? ? quote_line_cost.quote_line_cost : 0
                    po_line.organization = line.organization
                    po_line.po_line_customer_po = line.quote_line_description
                    if po_line.save
                        line.update_attributes(po_line_id: po_line.id)
                    else
                        puts po_line.errors.to_yaml
                    end
                end
            end
            self.quote_active = true
        end
    end    
 end

end
