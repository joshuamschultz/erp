# == Schema Information
#
# Table name: customer_qualities
#
#  id                  :integer          not null, primary key
#  quality_name        :string(255)
#  quality_description :string(255)
#  quality_notes       :text(65535)
#  quality_active      :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class CustomerQuality < ActiveRecord::Base

  has_many :organizations
  has_many :item_revisions
  has_many :po_lines
  has_many :so_lines
  has_many :checklists
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :customer_quality_levels, :dependent => :destroy
  has_many :master_types, :through => :customer_quality_levels

  (validates_uniqueness_of :quality_name if validates_length_of :quality_name, :minimum => 1, :maximum => 50) if validates_presence_of :quality_name
  validates_length_of :quality_description, :maximum => 50
  validates_length_of :quality_notes, :maximum => 200

  after_initialize :default_values

  def default_values
      self.quality_active = true if self.quality_active.nil?
  end

  def self.quality_level_associations(customer_quality, params)
    if customer_quality
      quality_levels = params[:customer_quality_levels] || []
      customer_quality.customer_quality_levels.where.not(:master_type_id => quality_levels).destroy_all
    end

    if quality_levels
      quality_levels.each do |quality_id|
        unless customer_quality.customer_quality_levels.find_by_id(quality_id)
          customer_quality.customer_quality_levels.new(:master_type_id => quality_id).save
        end
      end
    end
  end

  def default_quality
    MasterType.find_by_type_category_and_type_value("default_customer_quality", self.id)
  end

end
