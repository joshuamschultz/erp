# == Schema Information
#
# Table name: item_selected_names
#
#  id               :integer          not null, primary key
#  item_revision_id :integer
#  item_alt_name_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ItemSelectedName < ActiveRecord::Base
  belongs_to :item_revision
  # belongs_to :item, :through => :item_revision
  belongs_to :item_alt_name

  attr_accessor :item_revision_id, :item_alt_name_id, :item_name
  attr_accessor :item_name

  def with_alt_name
    self.item_revision.item.item_part_no + " (#{self.item_alt_name.item_alt_identifier})"
  end

  has_many :po_lines
  has_many :so_lines

  validates :item_alt_name_id, :uniqueness => { :scope => :item_revision_id, :message => "already exists!" }

end
