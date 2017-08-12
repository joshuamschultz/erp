# == Schema Information
#
# Table name: test_items
#
#  id              :integer          not null, primary key
#  test_package_id :integer
#  item_name       :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class TestItem < ActiveRecord::Base
  belongs_to :test_package
  attr_accessible :test_package_id, :item_name
 
end
