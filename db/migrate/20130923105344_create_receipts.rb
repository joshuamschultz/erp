class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :organization
      t.integer :receipt_type_id
      t.string :receipt_check_code
      t.decimal :receipt_check_amount
      t.string :receipt_check_no
      t.string :receipt_identifier
      t.string :receipt_description
      t.text :receipt_notes
      t.string :receipt_status
      t.boolean :receipt_active
      t.integer :receipt_created_id
      t.integer :receipt_updated_id

      t.timestamps
    end
    add_index :receipts, :organization_id
  end
end
