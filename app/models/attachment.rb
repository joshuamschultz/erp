# == Schema Information
#
# Table name: attachments
#
#  id                          :integer          not null, primary key
#  attachable_id               :integer
#  attachable_type             :string(255)
#  attachment_file_name        :string(255)
#  attachment_file_size        :string(255)
#  attachment_content_type     :string(255)
#  attachment_revision_title   :string(255)
#  attachment_revision_date    :date
#  attachment_effective_date   :date
#  attachment_name             :string(255)
#  attachment_description      :string(255)
#  attachment_document_type    :string(255)
#  attachment_document_type_id :integer
#  attachment_notes            :text(65535)
#  attachment_public           :boolean          default(FALSE)
#  attachment_active           :boolean          default(FALSE)
#  attachment_status           :string(255)
#  attachment_status_id        :integer
#  attachment_created_id       :integer
#  attachment_updated_id       :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#

class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'attachment_created_id'
  belongs_to :updated_by, class_name: 'User', foreign_key: 'attachment_updated_id'

  has_attached_file :attachment, url: '/attachments/documents/:id/:style/:basename.:extension',
                                 path: ':rails_root/public/attachments/documents/:id/:style/:basename.:extension'

  validates_attachment_content_type :attachment, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'application/pdf']

  before_create :create_level_default

  # attachment_status - pending/approved/rejected
  def is_process_type?
    attachable_type == 'ProcessType'
  end

  def create_level_default
    self.attachment_status = 'pending'
    # attachment_secret = SecureRandom.hex(4)
    # self.attachment_name = File.basename(self.attachment_file_name, ".*") + "_" + attachment_secret if (self.attachment_name.nil? || self.attachment_name == "") && self.attachment_file_name.present?
    self.attachment_name = attachment_file_name if (attachment_name.nil? || attachment_name == '') && attachment_file_name.present?
  end

  def attachment_fields
    # self[:attachment_name] = CommonActions.linkable(self.attachment.url(:original), self.attachment_name)
    atahment = {}
    attributes.each do |key, value|
      atahment[key] = value
    end
    atahment[:attachment_name] = CommonActions.linkable(attachment.url(:original), attachment_name)
    atahment[:effective_date] = attachment_revision_date ? attachment_revision_date.strftime('%m-%d-%Y') : ''
    atahment[:uploaded_date] = created_at.strftime('%m-%d-%Y')
    atahment[:uploaded_by] = created_by ? created_by.name : ''
    atahment[:approved_by] = ''
    # self[:links] = "<a href='#{self.attachment.url(:original)}' target='_blank' class='btn-action glyphicons file btn-success'><i></i></a> "
    atahment
  end

  def attachment_url(type)
    case type
    when 'url'
      attachment.url(:original)
    when 'link'
      "Current File : <a href='#{attachment.url(:original)}' target='_blank'>#{attachment_name}</a>".html_safe
    when 'link_action'
      "Attachment : <a href='#{attachment.url(:original)}' target='_blank'>#{attachment_name}</a>".html_safe
    else
      ''
    end
  end
end
