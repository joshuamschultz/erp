class CreateCheckRegisters < ActiveRecord::Migration
  def change
    create_table :check_registers do |t|
      t.date :transaction_date
      t.string :check_code
      t.integer :organization_id
      t.decimal :amount
      t.decimal :deposit
      t.decimal :balance
      t.boolean :rec

      t.timestamps
    end
  end
end
