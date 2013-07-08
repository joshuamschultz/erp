class TestItem < ActiveRecord::Base
  belongs_to :test_package
  attr_accessible :test_package_id, :item_name
 
end
