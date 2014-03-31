class CreatePayableAccounts < ActiveRecord::Migration
  def change
    create_table :payable_accounts do |t|
      t.references :payable
      t.references :gl_account
      t.string :payable_account_description
      t.decimal :payable_account_amount, :precision => 25, :scale => 10, :default => 0
      t.integer :payable_account_created_id
      t.integer :payable_account_updated_id

      t.timestamps
    end
    add_index :payable_accounts, :payable_id
    add_index :payable_accounts, :gl_account_id
  end
end
