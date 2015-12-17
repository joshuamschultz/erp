class Commodity < ActiveRecord::Base
  after_initialize :default_values

  def default_values
    self.commodity_active = true if self.attributes.has_key?("commodity_active") && self.commodity_active.nil?
  end
  
  attr_accessible :commodity_active, :commodity_created_id, :commodity_description, 
  :commodity_identifier, :commodity_notes, :commodity_updated_id

  (validates_uniqueness_of :commodity_identifier if validates_length_of :commodity_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :commodity_identifier

  validates_length_of :commodity_description, :commodity_notes, :maximum => 50

  def self.auto_save(commodities)
  	pre_commodities = Commodity.select(:commodity_identifier)
  	commodities.each do |commodity|
  		unless pre_commodities.any?{|pre_commodity| pre_commodity.commodity_identifier == commodity}
  			Commodity.create(commodity_active: 1,commodity_identifier: commodity)		 
  		end
  	end
  end
end