# == Schema Information
#
# Table name: specifications
#
#  id                        :integer          not null, primary key
#  specification_active      :boolean
#  specification_identifier  :string(255)
#  specification_description :string(255)
#  specification_notes       :text(65535)
#  created_at                :datetime
#  updated_at                :datetime
#

class Specification < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :item_specifications, dependent: :destroy
  has_many :item_revisions, through: :item_specifications
  has_many :process_type_specifications, dependent: :destroy
  has_many :process_types, through: :process_type_specifications

  has_one :attachment, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachment, allow_destroy: true

  has_one :notification, as: :notable, dependent: :destroy
  accepts_nested_attributes_for :notification, allow_destroy: true

  before_save :before_save_values
  after_initialize :default_values

  # (validates_uniqueness_of :specification_identifier if validates_length_of :specification_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :specification_identifier
  # validates_length_of :specification_description, :maximum => 50

  default_scope { order('specification_identifier ASC') }

  def redirect_path
    specification_path(self)
  end

  def default_values
    self.specification_active = true if specification_active.nil?
  end

  def before_save_values
    self.specification_identifier = attachment.attachment_name
    self.specification_description = attachment.attachment_description
    end

  def self.item_specification(item)
    # create an array called specifications
    specifications = []
    # Create a loop for each revision
    Item.find(item).item_revisions.each do |item_revision|
      next unless item_revision.present?
      # Grab all the specs for that revision
      # and load them into the specifications array
      item_revision.item_specifications.each do |process|
        specifications << process.specification if process.present?
      end
    end
    # get all processes with a a part
    process_types = ProcessType.item_process_type(item)
    # grab all specs with the process and create a loop
    # Add those to the specifications array as well.
    process_specifications = ProcessType.process_type_specifications(process_types)
    process_specifications.each do |process_spec|
      specifications << process_spec
    end
    # get rid of duplicates.
    specifications.uniq.compact
  end
  # TODO: if this what I think it is, to assign specs to new parts or something.
  # We need to change
  # Not all specs go to the part. Some go to the part, and but those that come from
  # a process need to have that same process associated. Ex, not a black oxide spec
  # to a part. The part should get that spec when we assign the b/o process.
  # Check what the spec array is used for.
end
