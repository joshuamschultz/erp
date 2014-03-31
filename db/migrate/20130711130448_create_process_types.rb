class CreateProcessTypes < ActiveRecord::Migration
  def change
    create_table :process_types do |t|
      t.string :process_short_name
      t.string :process_description
      t.text :process_notes
      t.boolean :process_active, :default => true
      t.integer :process_created_id
      t.integer :process_updated_id

      t.timestamps
    end
  end
end
