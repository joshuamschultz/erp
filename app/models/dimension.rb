# == Schema Information
#
# Table name: dimensions
#
#  id                    :integer          not null, primary key
#  dimension_identifier  :string(255)
#  dimension_description :string(255)
#  dimension_notes       :text(65535)
#  dimension_active      :boolean
#  dimension_created_id  :integer
#  dimension_updated_id  :integer
#  created_at            :datetime
#  updated_at            :datetime
#

class Dimension < ActiveRecord::Base
  has_many :item_part_dimensions, :dependent => :destroy

  (validates_uniqueness_of :dimension_identifier if validates_length_of :dimension_identifier, :minimum => 1, :maximum => 50) if validates_presence_of :dimension_identifier

  after_initialize :default_values

  def default_values
	   self.dimension_active = true if self.dimension_active.nil?
  end

end
