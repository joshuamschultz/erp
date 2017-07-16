# == Schema Information
#
# Table name: customer_quality_levels
#
#  id                  :integer          not null, primary key
#  customer_quality_id :integer
#  master_type_id      :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class CustomerQualityLevel < ActiveRecord::Base
  attr_accessible :customer_quality_id, :master_type_id

  belongs_to :customer_quality
  belongs_to :master_type, -> {where type_category: customer_quality_level}

end
