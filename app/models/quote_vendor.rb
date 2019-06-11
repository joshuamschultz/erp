# == Schema Information
#
# Table name: quote_vendors
#
#  id                      :integer          not null, primary key
#  quote_id                :integer
#  organization_id         :integer
#  quote_vendor_status     :string(255)
#  quote_vendor_created_id :integer
#  quote_vendor_updated_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class QuoteVendor < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :quote
  belongs_to :organization

  has_many :quote_line_costs, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :quote_line_costs

  def process_quote_line_costs
      self.quote.quote_lines.each do |quote_line|
            QuoteLineCost.create(quote_vendor_id: self.id, quote_line_id: quote_line.id)
        end
  end

  def redirect_path
      edit_quote_quote_vendor_path(self.quote_id, self.id)      
  end

end
