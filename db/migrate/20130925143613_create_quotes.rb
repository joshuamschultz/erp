class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.references :organization
      t.references :po_header
      t.string :quote_identifier
      t.string :quote_description
      t.decimal :quote_total, :precision => 25, :scale => 10, :default => 0
      t.string :quote_status
      t.text :quote_notes
      t.boolean :quote_active
      t.integer :quote_created_id
      t.integer :quote_updated_id

      t.timestamps
    end
    add_index :quotes, :organization_id
    add_index :quotes, :po_header_id
  end
end
