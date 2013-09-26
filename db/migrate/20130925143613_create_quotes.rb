class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :quote_identifier
      t.string :quote_description
      t.decimal :quote_total
      t.string :quote_status
      t.text :quote_notes
      t.boolean :quote_active
      t.integer :quote_created_id
      t.integer :quote_updated_id

      t.timestamps
    end
  end
end
