class AddDepositCheckIdToReceipts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :deposit_check_id, :integer
  end
end
