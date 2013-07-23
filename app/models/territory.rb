class Territory < ActiveRecord::Base
  after_initialize :default_values

  extend ValidatesFormattingOf::ModelAdditions

  def default_values
    self.territory_active ||= true
  end

  attr_accessible :territory_active, :territory_created_id, :territory_description, 
  :territory_identifier, :territory_updated_id, :territory_zip

  (validates_uniqueness_of :territory_identifier if validates_length_of :territory_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :territory_identifier

  validates_length_of :territory_description, :maximum => 50

  # validates_formatting_of :territory_zip, :using => :us_zip if validates_presence_of :territory_zip

  has_many :organizations
end
