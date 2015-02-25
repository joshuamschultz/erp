class MaxControlString < ActiveRecord::Base
  attr_accessible :control_string
  validates :control_string, uniqueness: true
end
