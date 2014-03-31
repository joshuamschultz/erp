class CreatePrints < ActiveRecord::Migration
  def change
    create_table :prints do |t|
      t.boolean :print_active
      t.integer :print_created_id
      t.integer :print_updated_id
      t.string :print_identifier
      t.string :print_description
      t.text :print_notes

      t.timestamps
    end
  end
end
