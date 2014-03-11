class CreateQuotesPoHeaders < ActiveRecord::Migration
  def change
    create_table :quotes_po_headers do |t|
      t.references :po_header
      t.references :quote
      t.timestamps
    end
    add_index :quotes_po_headers, :po_header_id
    add_index :quotes_po_headers, :quote_id
  end
end
