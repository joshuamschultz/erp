class CreateCustomerQuoteLines < ActiveRecord::Migration
  def change
    create_table :customer_quote_lines do |t|
      t.references :customer_quote
      t.references :item
      t.references :item_revision
      t.references :item_alt_name
      t.references :quote_vendor
      t.string :customer_quote_line_description
      t.string :customer_quote_line_identifier
      t.integer :customer_quote_line_quantity
      t.decimal :customer_quote_line_cost, :precision => 25, :scale => 10, :default => 0
      t.string :customer_quote_line_status
      t.text :customer_quote_line_notes
      t.boolean :customer_quote_line_active
      t.integer :customer_quote_line_created_id
      t.integer :customer_quote_line_updated_id
      t.decimal :customer_quote_line_tooling_cost, :precision => 25, :scale => 10, :default => 0

      t.timestamps
    end
    add_index :customer_quote_lines, :customer_quote_id
    add_index :customer_quote_lines, :item_id
    add_index :customer_quote_lines, :item_revision_id
    add_index :customer_quote_lines, :item_alt_name_id
    add_index :customer_quote_lines, :quote_vendor_id
  end
end
