class CreateQuoteVendors < ActiveRecord::Migration
  def change
    create_table :quote_vendors do |t|
      t.references :quote
      t.references :organization
      t.string :quote_vendor_status
      t.integer :quote_vendor_created_id
      t.integer :quote_vendor_updated_id

      t.timestamps
    end
    add_index :quote_vendors, :quote_id
    add_index :quote_vendors, :organization_id
  end
end
