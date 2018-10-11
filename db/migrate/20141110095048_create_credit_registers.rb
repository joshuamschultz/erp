class CreateCreditRegisters < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_registers do |t|
      t.date :transaction_date
      t.integer :payment_id
      t.integer :organization_id
      t.decimal :amount
      t.decimal :balance
      t.boolean :rec

      t.timestamps
    end
  end
end
