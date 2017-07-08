class CompanyInfo < ActiveRecord::Base
  extend ValidatesFormattingOf::ModelAdditions

  has_one :image, as: :imageable
  accepts_nested_attributes_for :image, allow_destroy: true
  has_one :logo, as: :jointable
  accepts_nested_attributes_for :logo, allow_destroy: true

  validates_uniqueness_of :company_name if validates_length_of :company_name, minimum: 2, maximum: 50
  validates_length_of :company_address1, :company_address2, :company_fax, :company_website, :company_slogan, maximum: 50
  validates_formatting_of :company_phone1, using: :us_phone, allow_blank: true
end
