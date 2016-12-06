class Attachment < ActiveRecord::Base


  belongs_to :attachable, :polymorphic => true

  has_attached_file :attachment, :url  => "/attachments/documents/:id/:style/:basename.:extension",
  :path => ":rails_root/public/attachments/documents/:id/:style/:basename.:extension"

  # validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']

  validates_length_of :attachment_revision_title, :maximum => 50 if validates_presence_of :attachment_revision_title  or  :is_process_type? == false

  (validates :attachment_name, :uniqueness => { :scope => :attachable_type, :message => "already exists!" } if validates_length_of :attachment_name, :maximum => 50) if validates_presence_of :attachment_name

  validates_presence_of :attachment if :is_process_type? == false

  # attachment_status - pending/approved/rejected
  def is_process_type?
    self.attachable_type == "ProcessType"
  end

  before_create :create_level_default

  def create_level_default
      self.attachment_status = "pending"
      # attachment_secret = SecureRandom.hex(4)
      # self.attachment_name = File.basename(self.attachment_file_name, ".*") + "_" + attachment_secret if (self.attachment_name.nil? || self.attachment_name == "") && self.attachment_file_name.present?
      self.attachment_name = self.attachment_file_name if (self.attachment_name.nil? || self.attachment_name == "") && self.attachment_file_name.present?
  end

  def attachment_fields
      # self[:attachment_name] = CommonActions.linkable(self.attachment.url(:original), self.attachment_name)
      atahment = Hash.new
      self.attributes.each do |key, value|
        atahment[key] = value
      end
      atahment[:attachment_name] = CommonActions.linkable(self.attachment.url(:original), self.attachment_name)
      atahment[:effective_date] = self.attachment_revision_date ? self.attachment_revision_date.strftime("%m-%d-%Y") : ""
      atahment[:uploaded_date] = self.created_at.strftime("%m-%d-%Y")
      atahment[:uploaded_by] = self.created_by ? self.created_by.name : ""
      atahment[:approved_by] = ""
      # self[:links] = "<a href='#{self.attachment.url(:original)}' target='_blank' class='btn-action glyphicons file btn-success'><i></i></a> "
      atahment
  end

  belongs_to :created_by, :class_name => "User", :foreign_key => "attachment_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "attachment_updated_id"

  def attachment_url(type)
      case(type)
          when "url"
              self.attachment.url(:original)
          when "link"
              "Current File : <a href='#{self.attachment.url(:original)}' target='_blank'>#{self.attachment_name}</a>".html_safe
          when "link_action"
             "Attachment : <a href='#{self.attachment.url(:original)}' target='_blank'>#{self.attachment_name}</a>".html_safe
          else
              ""
      end
  end
end
