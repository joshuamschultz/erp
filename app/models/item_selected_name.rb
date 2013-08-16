class ItemSelectedName < ActiveRecord::Base
  belongs_to :item_revision
  # belongs_to :item, :through => :item_revision
  belongs_to :item_alt_name

  attr_accessible :item_revision_id, :item_alt_name_id, :item_name
  attr_accessor :item_name

  def with_alt_name
    self.item_revision.item.item_part_no + " (#{self.item_alt_name.item_alt_identifier})"
  end

  has_many :po_lines

end
