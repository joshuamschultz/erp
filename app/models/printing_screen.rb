class PrintingScreen < ActiveRecord::Base
  belongs_to :payment
  attr_accessible :status
end
