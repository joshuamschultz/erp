class QuoteLineCost < ActiveRecord::Base
  belongs_to :quote_vendor
  belongs_to :quote_line
  attr_accessible :quote_line_cost, :quote_line_cost_created_id, :quote_line_cost_notes, 
  :quote_line_cost_updated_id, :quote_vendor_id, :quote_line_id, :quote_line_cost_tooling,
  :quote_line_cost_lead, :quote_line_cost_description

  validates :quote_line_id, :uniqueness => { :scope => :quote_vendor_id, :message => "duplicate item entry!" }
end
