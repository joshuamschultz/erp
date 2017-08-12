# == Schema Information
#
# Table name: elements
#
#  id                 :integer          not null, primary key
#  element_name       :string(255)
#  element_symbol     :string(255)
#  element_notes      :text(65535)
#  element_created_id :integer
#  element_updated_id :integer
#  element_active     :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

class Element < ActiveRecord::Base
  has_many :material_elements

  after_initialize :default_values

  validates_uniqueness_of :element_name if validates_presence_of :element_name, :element_symbol

  def default_values
    self.element_active = true if attributes.key?('element_active') && element_active.nil?
  end

  def element_symbol_name
    element_name + " (#{element_symbol})"
  end
end
