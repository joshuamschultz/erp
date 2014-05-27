class CreateDepositChecks < ActiveRecord::Migration
  def change
    create_table :deposit_checks do |t|
      t.string :status
      t.references :payment

      t.timestamps
    end
    add_index :deposit_checks, :payment_id
  end
end
