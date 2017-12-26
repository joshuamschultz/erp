# == Schema Information
#
# Table name: owners
#
#  id                       :integer          not null, primary key
#  owner_identifier         :string(255)
#  owner_description        :string(255)
#  owner_commission_type_id :integer
#  owner_commission_amount  :decimal(25, 10)  default(0.0)
#  owner_active             :boolean          default(TRUE)
#  created_at               :datetime
#  updated_at               :datetime
#

class Owner < ActiveRecord::Base
  has_many :items
  has_many :item_revisions
  belongs_to :commission_type, -> {where type_category:  'commission_type'},
              :class_name => "MasterType", :foreign_key => "owner_commission_type_id"

  (validates_uniqueness_of :owner_identifier if validates_length_of :owner_identifier, :minimum => 2, :maximum => 20) if validates_presence_of :owner_identifier
  validates_length_of :owner_description, :maximum => 50
  validates_length_of :owner_commission_amount, :maximum => 20 if validates_presence_of :owner_commission_amount
  validates_presence_of :commission_type
  after_initialize :default_values

  def default_values
    self.owner_active = true if self.owner_active.nil?
  end

end
