class VendorQuality < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :quality_active, :quality_created_id, :quality_description, 
  :quality_name, :quality_notes, :quality_updated_id

   after_initialize :default_values

  def default_values
    self.quality_active = true if self.quality_active.nil?
  end

  before_validation :before_validate_values

  def before_validate_values
      self.quality_name = self.quality_name.upcase
  end

  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 1, :maximum => 1) if validates_presence_of :quality_name

  validates_format_of :quality_name, :with => /^[a-zA-Z]*$/i, :message => "can only contain letter!"

  validates_length_of :quality_description, :maximum => 50

  validates_length_of :quality_notes, :maximum => 200

  has_many :organizations

  has_many :max_quality_customers, :class_name => "Organization", :foreign_key => "customer_max_quality_id"

  has_many :min_quality_customers, :class_name => "Organization", :foreign_key => "customer_min_quality_id"

  has_many :item_revisions
  has_many :po_lines
  has_many :attachments, :as => :attachable, :dependent => :destroy

  def redirect_path
      vendor_quality_path(self)
  end

  def default_quality
      MasterType.find_by_type_category_and_type_value("default_vendor_quality", self.id)
  end

end
