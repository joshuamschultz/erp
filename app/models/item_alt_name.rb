# == Schema Information
#
# Table name: item_alt_names
#
#  id                   :integer          not null, primary key
#  item_alt_identifier  :string(255)
#  item_alt_description :string(255)
#  item_alt_notes       :text(65535)
#  item_alt_active      :boolean
#  item_alt_created_id  :integer
#  item_alt_updated_id  :integer
#  created_at           :datetime
#  updated_at           :datetime
#  organization_id      :integer
#  item_id              :integer
#

class ItemAltName < ActiveRecord::Base
  belongs_to :item
  belongs_to :organization, -> {where organization_type_id: MasterType.find_by_type_value("customer").id}, optional: true

  has_many :item_selected_names, :dependent => :destroy
  has_many :item_revisions, :through => :item_selected_names
  has_many :po_lines
  has_many :so_lines
  has_many :quote_lines
  has_many :quality_actions

  has_many :transferring_po_lines, :foreign_key => "alt_name_transfer_id", :class_name => "PoLine"
  has_many :inventory_adjustments, :dependent => :destroy

  # validates :item_id, :uniqueness => {:scope => :organization_id, :message => "already exists for the customer!" }
  # validates_uniqueness_of :item_alt_identifier
  validates_presence_of :item#, :organization
  validates_length_of :item_alt_identifier, :maximum => 50 if validates_presence_of :item_alt_identifier

  def alt_item_name
      self.item_alt_identifier + (self.organization ? " (#{self.organization.organization_name})" : "")
  end

  def self.get_alt_names(get_all: true)
    # alt_names = ItemAltName.where("organization_id is not NULL")
    alt_names = ItemAltName.all
    item_alt_names = []
    alt_names.each do |alt_item|
      if alt_item.item.present?
        if (get_all || (alt_item.item_alt_identifier != alt_item.item.item_part_no))
          item_alt_names << alt_item
        end
      end
    end
    item_alt_names
  end
end
