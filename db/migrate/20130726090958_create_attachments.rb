class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.string :attachment_title
      t.string :attachment_description
      t.text :attachment_notes
      t.string :attachment_file_name
      t.string :attachment_file_size
      t.string :attachment_content_type
      t.boolean :attachment_public
      t.boolean :attachment_active
      t.integer :attachment_created_id
      t.integer :attachment_updated_id

      t.timestamps
    end
  end
end
