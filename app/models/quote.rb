class Quote < ActiveRecord::Base
  has_many :quote_vendors, :dependent => :destroy
  has_many :quote_lines, :dependent => :destroy

  attr_accessible :quote_active, :quote_created_id, :quote_description, :quote_identifier, 
  :quote_notes, :quote_status, :quote_total, :quote_updated_id


 def self.process_quote_associations(quote, params)
 	if quote
 		vendors = params[:vendors] || []
  		quote.quote_vendors.where(:organization_id != vendors).destroy_all

  		if vendors
	      	vendors.each do |vendor_id|
				unless quote.quote_vendors.find_by_organization_id(vendor_id)
					  quote.quote_vendors.new(:organization_id => vendor_id).save
				end
	      	end
	    end
 	end
 end

end
