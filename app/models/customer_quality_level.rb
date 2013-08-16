class CustomerQualityLevel < ActiveRecord::Base
  attr_accessible :customer_quality_id, :master_type_id
  
  belongs_to :customer_quality
  belongs_to :master_type, :conditions => ['type_category = ?', 'customer_quality_level']

end
