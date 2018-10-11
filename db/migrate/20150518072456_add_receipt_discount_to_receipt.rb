class AddReceiptDiscountToReceipt < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :receipt_discount, :decimal, :precision => 25, :scale => 10, :default => 0
  end
end
