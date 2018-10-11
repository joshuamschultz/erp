class AddReceiptTypeAndCheckIdentifierAndActiveToDepositChecks < ActiveRecord::Migration[5.0]
  def change
    add_column :deposit_checks, :receipt_type, :string
    add_column :deposit_checks, :check_identifier, :string
    add_column :deposit_checks, :active, :integer
  end
end
