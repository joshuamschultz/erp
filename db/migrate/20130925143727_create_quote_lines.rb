class CreateQuoteLines < ActiveRecord::Migration[5.0]
  def change
    create_table :quote_lines do |t|
      t.references :quote
      t.references :item
      t.references :item_revision
      t.references :item_alt_name
      t.references :po_line
      t.references :organization
      t.string :quote_line_description
      t.string :quote_line_identifier
      t.integer :quote_line_quantity
      t.decimal :quote_line_cost, :precision => 25, :scale => 10, :default => 0
      t.decimal :quote_line_total, :precision => 25, :scale => 10, :default => 0
      t.string :quote_line_status
      t.text :quote_line_notes
      t.boolean :quote_line_active, :default => false
      t.integer :quote_line_created_id
      t.integer :quote_line_updated_id

      t.timestamps
    end
    add_index :quote_lines, :quote_id
    add_index :quote_lines, :item_id
    add_index :quote_lines, :item_revision_id
    add_index :quote_lines, :item_alt_name_id
    add_index :quote_lines, :po_line_id
    add_index :quote_lines, :organization_id
  end
end
