class Checklist < ActiveRecord::Base
  belongs_to :quality_lot
  belongs_to :po_line
  belongs_to :customer_quality
  attr_accessible :checklist_status, :quality_lot_id, :po_line_id, :customer_quality_id

  has_many :check_list_lines

  validate :quality_lot, :po_line, :customer_quality
end
