# == Schema Information
#
# Table name: territories
#
#  id                    :integer          not null, primary key
#  territory_active      :boolean
#  territory_identifier  :string(255)
#  territory_description :string(255)
#  territory_zip         :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Territory < ActiveRecord::Base
  extend ValidatesFormattingOf::ModelAdditions

  has_many :organizations

  after_initialize :default_values

  (validates_uniqueness_of :territory_identifier if validates_length_of :territory_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :territory_identifier
  validates_length_of :territory_description, :maximum => 50
  # validates_formatting_of :territory_zip, :using => :us_zip if validates_presence_of :territory_zip

  def default_values
    self.territory_active = true if self.territory_active.nil?
  end

end
