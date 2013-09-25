class CreateReceiptLines < ActiveRecord::Migration
  def change
    create_table :receipt_lines do |t|
      t.references :receipt
      t.references :receivable
      t.decimal :receipt_line_amount, :precision => 25, :scale => 10, :default => 0
      t.integer :receipt_line_created_id
      t.integer :receipt_line_updated_id

      t.timestamps
    end 
    add_index :receipt_lines, :receipt_id
    add_index :receipt_lines, :receivable_id
  end
end
