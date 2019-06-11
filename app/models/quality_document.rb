# == Schema Information
#
# Table name: quality_documents
#
#  id                    :integer          not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  quality_document_name :string(255)
#

class QualityDocument < ActiveRecord::Base

   has_many :master_types, :dependent => :destroy

  has_one :logo, :as => :jointable

  accepts_nested_attributes_for :logo, :allow_destroy => true
	validates_presence_of :quality_document_name
	validates_presence_of :logo
end
	
