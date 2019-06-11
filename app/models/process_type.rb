# == Schema Information
#
# Table name: process_types
#
#  id                  :integer          not null, primary key
#  process_short_name  :string(255)
#  process_description :string(255)
#  process_notes       :text(65535)
#  process_active      :boolean          default(TRUE)
#  created_at          :datetime
#  updated_at          :datetime
#

class ProcessType < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :organization_processes, dependent: :destroy
  has_many :organizations, through: :organization_processes
  has_many :item_processes, dependent: :destroy
  has_many :item_revisions, through: :item_processes
  has_many :process_type_specifications, dependent: :destroy
  has_many :specifications, through: :process_type_specifications
  # has_many :specifications, through: :process_type_specifications

  has_one :attachment, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachment, allow_destroy: true

  has_one :notification, as: :notable, dependent: :destroy
  accepts_nested_attributes_for :notification, allow_destroy: true

  after_initialize :default_values
  before_save :before_save_values

  # (validates_uniqueness_of :process_short_name if validates_length_of :process_short_name, :minimum => 2, :maximum => 20) if validates_presence_of :process_short_name
  # validates_length_of :process_description, :maximum => 50

  default_scope { order('process_short_name ASC') }

  def default_values
    self.process_active = true if process_active.nil?
  end

  def self.process_item_associations(process_type, params)
    if process_type
      p params[:specs]
      specs = params[:specs] || []
      process_type.process_type_specifications.destroy_all
      if specs
        specs.each do |specification_id|
          unless process_type.process_type_specifications.find_by_specification_id(specification_id)
            # process_type.process_type_specifications.new(specification_id: specification_id).save
            process_type.process_type_specifications.build(:specification => Specification.find(specification_id)).save
          end
        end
      end
    end
  end

  def redirect_path
    process_type_path(self)
  end

  def before_save_values
    self.process_short_name = attachment.attachment_name
  end

  def self.item_process_type(item)
    process_types = []
    Item.find(item).item_revisions.each do |item_revision|
      next unless item_revision.present?
      item_revision.item_processes.each do |process|
        process_types << process.process_type if process.present?
      end
    end
    process_types = process_types.uniq.compact
    process_types
  end

  def self.process_type_specifications(process_types)
    specifications = []
    process_types.each do |process_type|
      next unless process_type.present?
      process_type.specifications.each do |pro_spec|
        specifications << pro_spec
      end
    end
    specifications.uniq
  end
end
