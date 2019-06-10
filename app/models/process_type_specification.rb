# == Schema Information
#
# Table name: process_type_specifications
#
#  id               :integer          not null, primary key
#  process_type_id  :integer
#  specification_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ProcessTypeSpecification < ActiveRecord::Base
  belongs_to :process_type
  belongs_to :specification
end
