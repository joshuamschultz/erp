class Item < ActiveRecord::Base
  attr_accessible :item_part_no, :item_quantity_in_hand, :item_quantity_on_order, :item_active,
  :item_created_id, :item_updated_id, :item_revisions_attributes

  has_many :item_revisions, :dependent => :destroy
  has_many :item_part_dimensions, :through => :item_revisions

  has_many :po_lines, :dependent => :destroy

  accepts_nested_attributes_for :item_revisions, :allow_destroy => true

  after_initialize :default_values

  def default_values
    self.item_active = true if self.item_active.nil?
  end
  
  (validates_uniqueness_of :item_part_no if validates_length_of :item_part_no, :minimum => 2, :maximum => 50) if validates_presence_of :item_part_no
   
  def current_revision
      self.item_revisions.order("created_at desc").first
  end

end
