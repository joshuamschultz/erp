class AddReceiptIdToReconcile < ActiveRecord::Migration
  def change
    add_column :reconciles, :receipt_id, :integer
  end
end
