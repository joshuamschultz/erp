class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :imageable_id
      t.string :imageable_type
      t.string :image_title
      t.string :image_description
      t.text :image_notes
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_content_type
      t.boolean :image_public
      t.boolean :image_active
      t.integer :image_created_id
      t.integer :image_updated_id

      t.timestamps
    end
  end
end
