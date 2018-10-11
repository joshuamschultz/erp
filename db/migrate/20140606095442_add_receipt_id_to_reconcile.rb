class AddReceiptIdToReconcile < ActiveRecord::Migration[5.0]
  def change
    add_column :reconciles, :receipt_id, :integer
  end
end
