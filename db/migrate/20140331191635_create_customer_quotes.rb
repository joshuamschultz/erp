class CreateCustomerQuotes < ActiveRecord::Migration
  def change
    create_table :customer_quotes do |t|
      t.references :organization
      t.string :customer_quote_identifier
      t.string :customer_quote_description
      t.string :customer_quote_status
      t.text :customer_quote_notes
      t.boolean :customer_quote_active
      t.integer :customer_quote_created_id
      t.integer :customer_quote_updated_id

      t.timestamps
    end
    add_index :customer_quotes, :organization_id
  end
end
