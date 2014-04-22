class CustomerQuoteLine < ActiveRecord::Base
	belongs_to :customer_quote
	belongs_to :item
	belongs_to :item_revision
	belongs_to :item_alt_name

	attr_accessible :customer_quote_line_active, :customer_quote_line_cost, :customer_quote_line_created_id,
	:customer_quote_line_description, :customer_quote_line_identifier, :customer_quote_line_notes, :lead_time,
	:customer_quote_line_quantity, :customer_quote_line_status, :customer_quote_line_updated_id, :customer_quote_id,
	:item_id, :item_revision, :item_alt_name_id, :customer_quote_line_tooling_cost, :customer_quote_line_total, :item_name_sub

	validates_numericality_of :customer_quote_line_quantity
	validates_presence_of :customer_quote_line_quantity, :customer_quote_line_cost
	#validates :item_alt_name_id, :uniqueness => { :scope => :customer_quote_id, :message => "duplicate item entry!" }, :if => :item_alt_name_id?

	before_create :process_before_create
	def process_before_create
		if self.item_alt_name_id.present?
			self.customer_quote_line_status = "open"
			self.customer_quote_line_active = false
			self.item = self.item_alt_name.item
			self.item_revision = self.item_alt_name.item.current_revision
			self.item_name_sub = ""
	    else
	    	self.customer_quote_line_status = "open"
			self.customer_quote_line_active = false
			p self.to_json
	    end
	end


	def self.get_line_items(quotes)
		item_id = []		
		quotes.quote_lines.each do |quote_line|
			option = Hash.new
			#if quote_line.item_alt_name && 	quote_line.item_alt_name.item_id
			if quote_line.item_alt_name.present?
				option["text"] = quote_line.item_alt_name.item_alt_identifier+" ("+quote_line.quote_line_quantity.to_s+")"
			else
				option["text"] = quote_line.item_name_sub+" ("+quote_line.quote_line_quantity.to_s+")"
			end
			option["value"] = quote_line.id
			item_id << option
			#end
		end
		item_id
	end

	before_save :process_before_save
	def process_before_save
       self.customer_quote_line_total = self.customer_quote_line_cost * self.customer_quote_line_quantity
  	end
end
