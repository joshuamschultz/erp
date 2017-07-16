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
  attr_accessible :element_active, :element_created_id, :element_name, 
  :element_notes, :element_symbol, :element_updated_id
  
  has_many :material_elements

  after_initialize :default_values 

  validates_uniqueness_of :element_name if validates_presence_of :element_name, :element_symbol
  
  def default_values
  		self.element_active = true if self.attributes.has_key?("element_active") && self.element_active.nil?
  end

  def element_symbol_name
  		self.element_name + " (#{self.element_symbol})"
  end

end
