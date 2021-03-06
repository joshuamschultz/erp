class CreateDepositChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :deposit_checks do |t|
      t.string :status
      t.references :payment

      t.timestamps
    end
    add_index :deposit_checks, :payment_id
  end
end
