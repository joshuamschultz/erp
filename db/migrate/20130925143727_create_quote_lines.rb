class CreateQuoteLines < ActiveRecord::Migration
  def change
    create_table :quote_lines do |t|
      t.references :quote
      t.references :item
      t.references :item_revision
      t.references :item_alt_name
      t.string :quote_line_identifier
      t.integer :quote_line_quantity
      t.decimal :quote_line_cost
      t.decimal :quote_line_total
      t.string :quote_line_status
      t.text :quote_line_notes
      t.boolean :quote_line_active
      t.integer :quote_line_created_id
      t.integer :quote_line_updated_id

      t.timestamps
    end
    add_index :quote_lines, :quote_id
    add_index :quote_lines, :item_id
    add_index :quote_lines, :item_revision_id
    add_index :quote_lines, :item_alt_name_id
  end
end
