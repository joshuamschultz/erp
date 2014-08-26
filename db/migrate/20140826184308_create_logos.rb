class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.integer :jointable_id
      t.string :jointable_type
      t.string :joint_title
      t.string :joint_description
      t.text :joint_notes
      t.string :joint_file_name
      t.string :joint_file_size
      t.string :joint_content_type
      t.datetime :joint_updated_at
      t.boolean :joint_public
      t.boolean :joint_active
      t.integer :joint_created_id
      t.integer :joint_updated_id
      t.timestamps
    end
  end
end
