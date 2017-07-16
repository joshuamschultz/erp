# == Schema Information
#
# Table name: quote_line_costs
#
#  id                          :integer          not null, primary key
#  quote_vendor_id             :integer
#  quote_line_id               :integer
#  quote_line_cost             :decimal(25, 10)  default(0.0)
#  quote_line_cost_notes       :text(65535)
#  quote_line_cost_created_id  :integer
#  quote_line_cost_updated_id  :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  quote_line_cost_tooling     :decimal(25, 10)  default(0.0)
#  quote_line_cost_lead        :string(255)
#  quote_line_cost_description :string(255)
#

class QuoteLineCost < ActiveRecord::Base
  belongs_to :quote_vendor
  belongs_to :quote_line
  attr_accessible :quote_line_cost, :quote_line_cost_created_id, :quote_line_cost_notes, 
  :quote_line_cost_updated_id, :quote_vendor_id, :quote_line_id, :quote_line_cost_tooling,
  :quote_line_cost_lead, :quote_line_cost_description

  validates :quote_line_id, :uniqueness => { :scope => :quote_vendor_id, :message => "duplicate item entry!" }
end
