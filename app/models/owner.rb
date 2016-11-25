class Owner < ActiveRecord::Base  

  after_initialize :default_values

  def default_values
    self.owner_active = true if self.owner_active.nil?
  end

 belongs_to :commission_type, -> {where type_category:  commission_type},
             :class_name => "MasterType", :foreign_key => "owner_commission_type_id"

  (validates_uniqueness_of :owner_identifier if validates_length_of :owner_identifier, :minimum => 2, :maximum => 20) if validates_presence_of :owner_identifier

  validates_length_of :owner_description, :maximum => 50

  validates_length_of :owner_commission_amount, :maximum => 20 if validates_presence_of :owner_commission_amount

  validates_presence_of :commission_type

  has_many :items
  has_many :item_revisions
end
