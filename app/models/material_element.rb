# == Schema Information
#
# Table name: material_elements
#
#  id                 :integer          not null, primary key
#  material_id        :integer
#  element_id         :integer
#  element_symbol     :string(255)
#  element_name       :string(255)
#  element_low_range  :decimal(25, 10)  default(0.0)
#  element_high_range :decimal(25, 10)  default(0.0)
#  element_active     :boolean          default(TRUE)
#  created_at         :datetime
#  updated_at         :datetime
#

class MaterialElement < ActiveRecord::Base
  belongs_to :material
  belongs_to :element
  belongs_to :created_by, class_name: 'User', foreign_key: 'element_created_id'
  belongs_to :updated_by, class_name: 'User', foreign_key: 'element_updated_id'
  has_many :quality_lot_materials, dependent: :destroy

  validates_presence_of :element, :element_high_range, :element_low_range
  validates :element_id, uniqueness: { scope: :material_id, message: 'already exists!' }

  after_initialize :default_values

  def default_values
    self.element_active = true if element_active.nil?
  end

  def element_with_symbol
    "#{element.element_name} (#{element.element_symbol})"
  end
end
