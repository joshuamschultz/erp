# == Schema Information
#
# Table name: test_packages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TestPackage < ActiveRecord::Base
  attr_accessible :name

  has_many :test_items

  (validates_uniqueness_of :name if validates_length_of :name, :minimum => 2, :maximum => 10) if validates_presence_of :name

end
