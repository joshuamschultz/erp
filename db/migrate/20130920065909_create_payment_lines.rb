class CreatePaymentLines < ActiveRecord::Migration
  def change
    create_table :payment_lines do |t|
      t.references :payment
      t.references :payable
      t.decimal :payment_line_amount, :precision => 25, :scale => 10, :default => 0  
      t.integer :payment_line_created_id
      t.integer :payment_line_updated_id

      t.timestamps
    end
    add_index :payment_lines, :payment_id
    add_index :payment_lines, :payable_id
  end
end
