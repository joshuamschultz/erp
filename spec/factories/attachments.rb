include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :attachment do |f|
    f.attachment { fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf') }
    f.attachment_name 'test.pdf'
  end
end
