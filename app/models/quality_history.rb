class QualityHistory < ActiveRecord::Base
  attr_accessible :quality_lot_id, :quality_status, :user_id
  belongs_to :quality_lot
end
