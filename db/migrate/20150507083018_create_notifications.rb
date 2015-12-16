class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notable_id
      t.string :notable_type
      t.string :note_status
      t.integer :user_id

      t.timestamps
    end
  end
end
