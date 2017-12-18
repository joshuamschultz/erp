# == Schema Information
#
# Table name: vendor_qualities
#
#  id                  :integer          not null, primary key
#  quality_name        :string(255)
#  quality_description :string(255)
#  quality_notes       :text(65535)
#  quality_active      :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class VendorQuality < ActiveRecord::Base
  has_many :organizations
  has_many :max_quality_customers, :class_name => "Organization", :foreign_key => "customer_max_quality_id"
  has_many :min_quality_customers, :class_name => "Organization", :foreign_key => "customer_min_quality_id"
  has_many :item_revisions
  has_many :po_lines
  has_many :attachments, :as => :attachable, :dependent => :destroy

  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 1, :maximum => 1) if validates_presence_of :quality_name
  validates_format_of :quality_name, :with => /^[a-zA-Z]*$/i, :multiline => true,:message => "can only contain letter!"
  validates_length_of :quality_description, :maximum => 50
  validates_length_of :quality_notes, :maximum => 200

  before_validation :before_validate_values
  after_initialize :default_values

  def default_values
    self.quality_active = true if self.quality_active.nil?
  end

  def before_validate_values
      self.quality_name = self.quality_name.upcase
  end

  def default_quality
      MasterType.find_by_type_category_and_type_value("default_vendor_quality", self.id)
  end

end
