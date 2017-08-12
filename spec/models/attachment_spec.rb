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

require 'spec_helper'

describe Attachment do

  it "has a valid attachment" do
     FactoryGirl.create(:attachment).should be_valid
  end
end
