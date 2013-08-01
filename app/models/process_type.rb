class ProcessType < ActiveRecord::Base
  attr_accessible :process_active, :process_created_id, :process_description, 
  :process_notes, :process_short_name, :process_updated_id

  after_initialize :default_values

  def default_values
    self.process_active = true if self.process_active.nil?
  end

  (validates_uniqueness_of :process_short_name if validates_length_of :process_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :process_short_name

  validates_length_of :process_description, :maximum => 50

  has_many :organization_processes, :dependent => :destroy

  has_many :item_processes, :dependent => :destroy
end
