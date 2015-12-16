class MaxControlString < ActiveRecord::Base
  attr_accessible :control_string, :control_string_second
  validates :control_string, uniqueness: true
end
