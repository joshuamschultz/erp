class VendorQuality < ActiveRecord::Base
  attr_accessible :quality_active, :quality_created_id, :quality_description, :quality_name, 
  :quality_notes, :quality_updated_id

   after_initialize :default_values

  def default_values
    self.quality_active = true if self.quality_active.nil?
  end

  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 1, :maximum => 50) if validates_presence_of :quality_name

  validates_length_of :quality_description, :maximum => 50

  validates_length_of :quality_notes, :maximum => 200

  has_many :organizations

  has_many :max_quality_customers, :class_name => "Organization", :foreign_key => "customer_max_quality_id"

  has_many :min_quality_customers, :class_name => "Organization", :foreign_key => "customer_min_quality_id"

  has_many :item_revisions
end
