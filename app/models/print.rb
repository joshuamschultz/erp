# == Schema Information
#
# Table name: prints
#
#  id                :integer          not null, primary key
#  print_active      :boolean
#  print_created_id  :integer
#  print_updated_id  :integer
#  print_identifier  :string(255)
#  print_description :string(255)
#  print_notes       :text(65535)
#  created_at        :datetime
#  updated_at        :datetime
#

class Print < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # has_one :item_print, :dependent => :destroy
  # has_one :item_revision, :through => :item_print
  has_many :item_revisions
  has_one :attachment, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachment, allow_destroy: true
  has_one :notification, as: :notable, dependent: :destroy
  accepts_nested_attributes_for :notification, allow_destroy: true

  after_initialize :default_values
  before_save :before_save_values

  def default_values
    self.print_active = true if attributes.key?('print_active') && print_active.nil?
  end

  def before_save_values
    self.print_identifier = attachment.attachment_name
  end
end
