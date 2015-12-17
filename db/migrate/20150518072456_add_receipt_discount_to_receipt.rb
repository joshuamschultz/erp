class AddReceiptDiscountToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :receipt_discount, :decimal, :precision => 25, :scale => 10, :default => 0
  end
end
