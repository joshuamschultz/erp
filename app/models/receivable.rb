class Receivable < ActiveRecord::Base
  has_many :receivable_lines
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_header
  attr_accessible :receivable_active, :receivable_cost, :receivable_created_id, :receivable_description, :receivable_discount, :receivable_identifier, :receivable_notes, :receivable_status, :receivable_total, :receivable_updated_id
end
