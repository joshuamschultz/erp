class SoLine < ActiveRecord::Base
  belongs_to :so_header
  belongs_to :item
  belongs_to :organization
  belongs_to :item_alt_name
  attr_accessible :so_line_cost, :so_line_created_id, :so_line_freight, :so_line_price, :so_line_quantity, 
  :so_line_status, :so_line_updated_id, :organization_id, :item_id, :so_header_id, :item_alt_name_id
  validates_presence_of :so_header
end
