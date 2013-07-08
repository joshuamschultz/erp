class TestPackage < ActiveRecord::Base
  attr_accessible :name

  has_many :test_items
end
