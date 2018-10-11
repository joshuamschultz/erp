class AddReceiptIdToDepositCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :deposit_checks, :receipt_id, :integer
  end
end
