# == Schema Information
#
# Table name: materials
#
#  id                   :integer          not null, primary key
#  material_short_name  :string(255)
#  material_description :string(255)
#  material_notes       :text(65535)
#  material_active      :boolean          default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#

class Material < ActiveRecord::Base
  
  has_many :item_revisions
  has_many :material_elements, inverse_of: :material, dependent: :destroy
  has_many :elements, through: :material_elements
  accepts_nested_attributes_for :material_elements, reject_if: :all_blank, allow_destroy: true

  belongs_to :created_by, class_name: 'User', foreign_key: 'material_created_id'
  belongs_to :updated_by, class_name: 'User', foreign_key: 'material_updated_id'

  (validates_uniqueness_of :material_short_name if validates_length_of :material_short_name, minimum: 2, maximum: 20) if validates_presence_of :material_short_name
  (validates_length_of :material_description, minimum: 2, maximum: 50) if validates_presence_of :material_description
  validates_length_of :material_notes, maximum: 200

  after_initialize :default_values

  def default_values
    self.material_active = true if attributes.key?('material_active') && material_active.nil?
  end
end
