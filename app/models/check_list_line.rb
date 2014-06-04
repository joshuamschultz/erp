class CheckListLine < ActiveRecord::Base
  belongs_to :checklist
  belongs_to :master_type
  attr_accessible :check_list_status, :checklist_id,  :master_type_id
  belongs_to :master_type, :conditions => ['type_category = ?', 'customer_quality_level']
  validate :master_type, :checklist
end
