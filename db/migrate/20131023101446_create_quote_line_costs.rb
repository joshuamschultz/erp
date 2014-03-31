class CreateQuoteLineCosts < ActiveRecord::Migration
  def change
    create_table :quote_line_costs do |t|
      t.references :quote_vendor
      t.references :quote_line
      t.decimal :quote_line_cost, :precision => 25, :scale => 10, :default => 0
      t.text :quote_line_cost_notes
      t.integer :quote_line_cost_created_id
      t.integer :quote_line_cost_updated_id

      t.timestamps
    end
    add_index :quote_line_costs, :quote_vendor_id
    add_index :quote_line_costs, :quote_line_id
  end
end
