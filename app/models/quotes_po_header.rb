# == Schema Information
#
# Table name: quotes_po_headers
#
#  id           :integer          not null, primary key
#  po_header_id :integer
#  quote_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class QuotesPoHeader < ActiveRecord::Base
  attr_accessor :quote_id, :po_header_id
  belongs_to :quote
  belongs_to :po_header
end
