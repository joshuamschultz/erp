class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type      
      t.string :attachment_file_name
      t.string :attachment_file_size
      t.string :attachment_content_type
      t.string :attachment_revision_title
      t.date :attachment_revision_date
      t.date :attachment_effective_date
      t.string :attachment_name
      t.string :attachment_description      
      t.string :attachment_document_type
      t.integer :attachment_document_type_id      
      t.text :attachment_notes
      t.boolean :attachment_public, :default => false
      t.boolean :attachment_active, :default => false
      t.string :attachment_status
      t.integer :attachment_status_id
      t.integer :attachment_created_id
      t.integer :attachment_updated_id
      t.timestamps
    end
  end
end
