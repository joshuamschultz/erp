class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_at
      t.datetime :end_at
      t.string :allDay
      t.string :user_name

      t.timestamps
    end
  end
end