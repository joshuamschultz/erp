# == Schema Information
#
# Table name: customer_quote_lines
#
#  id                               :integer          not null, primary key
#  customer_quote_id                :integer
#  item_id                          :integer
#  item_revision_id                 :integer
#  item_alt_name_id                 :integer
#  quote_vendor_id                  :integer
#  customer_quote_line_description  :string(255)
#  customer_quote_line_identifier   :string(255)
#  customer_quote_line_quantity     :integer
#  customer_quote_line_cost         :decimal(25, 10)  default(0.0)
#  customer_quote_line_status       :string(255)
#  customer_quote_line_notes        :text(65535)
#  customer_quote_line_active       :boolean
#  customer_quote_line_created_id   :integer
#  customer_quote_line_updated_id   :integer
#  customer_quote_line_tooling_cost :decimal(25, 10)  default(0.0)
#  created_at                       :datetime
#  updated_at                       :datetime
#  customer_quote_line_total        :decimal(25, 10)  default(0.0)
#  lead_time                        :string(255)
#  item_name_sub                    :string(255)
#  quote_id                         :integer
#

class CustomerQuoteLine < ActiveRecord::Base
	belongs_to :customer_quote
	belongs_to :item
	belongs_to :item_revision
	belongs_to :item_alt_name
	belongs_to :quote


	validates_numericality_of :customer_quote_line_quantity
	validates_presence_of :customer_quote_line_quantity, :customer_quote_line_cost
	#validates :item_alt_name_id, :uniqueness => { :scope => :customer_quote_id, :message => "duplicate item entry!" }, :if => :item_alt_name_id?

	before_create :process_before_create
	before_save :process_before_save

	def process_before_create
		if self.item_alt_name_id.present?
			self.customer_quote_line_status = "open"
			self.customer_quote_line_active = false
			self.item = self.item_alt_name.item
			self.item_revision = self.item_alt_name.current_revision
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

	def process_before_save
       self.customer_quote_line_total = self.customer_quote_line_cost * self.customer_quote_line_quantity
  	end
end
