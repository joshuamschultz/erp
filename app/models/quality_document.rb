class QualityDocument < ActiveRecord::Base
   attr_accessible :logo_attributes, :quality_document_name

   has_many :master_types, :dependent => :destroy

  has_one :logo, :as => :jointable

  accepts_nested_attributes_for :logo, :allow_destroy => true

end
	