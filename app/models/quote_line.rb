class QuoteLine < ActiveRecord::Base
  belongs_to :quote
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_alt_name
  
  attr_accessible :quote_line_active, :quote_line_cost, :quote_line_created_id, :quote_line_identifier, 
  :quote_line_notes, :quote_line_quantity, :quote_line_status, :quote_line_total, :quote_line_updated_id,
  :quote_id, :item_id, :item_revision_id, :item_alt_name_id
end
