# == Schema Information
#
# Table name: quality_action_numbers
#
#  id             :integer          not null, primary key
#  next_action_no :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

class QualityActionNumber < ActiveRecord::Base

  def self.get_next_quality_action_number
		temp = QualityActionNumber.first.next_action_no
		QualityActionNumber.first.update_attributes(:next_action_no => temp+1)
		temp
	end
end
