# == Schema Information
#
# Table name: printing_screens
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  payment_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class PrintingScreen < ActiveRecord::Base
  belongs_to :payment
end
