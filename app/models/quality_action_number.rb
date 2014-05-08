class QualityActionNumber < ActiveRecord::Base
  attr_accessible :next_action_no

  def self.get_next_quality_action_number
		temp = QualityActionNumber.first.next_action_no
		QualityActionNumber.first.update_attributes(:next_action_no => temp+1)
		temp
	end
end
