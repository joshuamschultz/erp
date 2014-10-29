class AddDepositCheckIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :deposit_check_id, :integer
  end
end
