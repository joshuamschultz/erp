class AddReceiptIdToDepositCheck < ActiveRecord::Migration
  def change
    add_column :deposit_checks, :receipt_id, :integer
  end
end
