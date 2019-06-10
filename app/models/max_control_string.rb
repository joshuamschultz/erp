# == Schema Information
#
# Table name: max_control_strings
#
#  id                    :integer          not null, primary key
#  control_string        :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  control_string_second :string(255)
#

class MaxControlString < ActiveRecord::Base
  validates :control_string, uniqueness: true
end
