class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.string :comment_type
      t.integer :commentable_id
      t.string  :commentable_type
      t.boolean :comment_active
      t.integer :comment_created_id
      t.integer :comment_updated_id

      t.timestamps
    end
  end
end
