class QualityDocument < ActiveRecord::Base
   attr_accessible :logo_attributes

  has_one :logo, :as => :jointable

  accepts_nested_attributes_for :logo, :allow_destroy => true

end
