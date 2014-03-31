class QuotesPoHeader < ActiveRecord::Base
  attr_accessible :quote_id, :po_header_id
  belongs_to :quote
  belongs_to :po_header
end
