class CheckEntry < ActiveRecord::Base
  attr_accessible :check_active, :check_code, :check_identifier

  validates_presence_of :check_identifier, :check_code
end
