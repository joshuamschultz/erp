class Owner < ActiveRecord::Base
  attr_accessible :owner_commission_amount, :owner_commission_type_id, :owner_description, 
  :owner_identifier, :owner_created_id, :owner_updated_id, :owner_active

  after_initialize :default_values

  def default_values
    self.owner_active ||= true
  end

  belongs_to :commission_type, :class_name => "MasterType", :foreign_key => "owner_commission_type_id", 
  :conditions => ['type_category = ?', 'commission_type']


  (validates_uniqueness_of :owner_identifier if validates_length_of :owner_identifier, :minimum => 2, :maximum => 20) if validates_presence_of :owner_identifier

  validates_length_of :owner_description, :maximum => 50

  validates_length_of :owner_commission_amount, :maximum => 20 if validates_presence_of :owner_commission_amount

  validates_presence_of :commission_type
end
