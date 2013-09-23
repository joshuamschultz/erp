class CreateReceiptLines < ActiveRecord::Migration
  def change
    create_table :receipt_lines do |t|
      t.references :receipt
      t.decimal :receipt_line_amount
      t.integer :receipt_line_created_id
      t.integer :receipt_line_updated_id

      t.timestamps
    end
    add_index :receipt_lines, :receipt_id
  end
end
