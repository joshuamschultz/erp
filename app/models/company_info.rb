class CompanyInfo < ActiveRecord::Base
  extend ValidatesFormattingOf::ModelAdditions

  attr_accessible :company_active, :company_address1, :company_address2, :company_created_id, 
  :company_fax, :company_mobile, :company_name, :company_phone1, :company_phone2, :company_slogan, 
  :company_updated_id, :company_website, :image_attributes

  validates_uniqueness_of :company_name if validates_length_of :company_name, :minimum => 2, :maximum => 50

  validates_length_of :company_address1, :company_address2, :company_fax, :company_website, :company_slogan, :maximum => 50

  validates_formatting_of :company_phone1, :using => :us_phone, :allow_blank => true

  # validates_formatting_of :company_website, :using => :url, :allow_blank => true

  has_one :image, :as => :imageable

  accepts_nested_attributes_for :image, :allow_destroy => true
end
