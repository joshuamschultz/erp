# == Schema Information
#
# Table name: reconcileds
#
#  id         :integer          not null, primary key
#  balance    :float(24)
#  created_at :datetime
#  updated_at :datetime
#

class Reconciled < ActiveRecord::Base
  attr_accessible :balance
end
