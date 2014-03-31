class CreateReceivableAccounts < ActiveRecord::Migration
  def change
    create_table :receivable_accounts do |t|
      t.references :receivable
      t.references :gl_account
      t.string :receivable_account_description
      t.decimal :receivable_account_amount, :precision => 25, :scale => 10, :default => 0
      t.integer :receivable_account_created_id
      t.integer :receivable_account_updated_id

      t.timestamps
    end
    add_index :receivable_accounts, :receivable_id
    add_index :receivable_accounts, :gl_account_id
  end
end
