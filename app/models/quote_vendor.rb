class QuoteVendor < ActiveRecord::Base
  belongs_to :quote
  belongs_to :organization

  has_many :quote_line_costs, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  
  attr_accessible :quote_vendor_created_id, :quote_vendor_status, 
  :quote_vendor_updated_id, :quote_id, :organization_id, :quote_line_costs_attributes

  accepts_nested_attributes_for :quote_line_costs

  def process_quote_line_costs
  		self.quote.quote_lines.each do |quote_line|
            QuoteLineCost.create(quote_vendor_id: self.id, quote_line_id: quote_line.id)
        end
  end

end
