class AddGlAccountId < ActiveRecord::Migration
  def change
  		add_column :payables, :gl_account_id, :integer
  		add_column :receivables, :gl_account_id, :integer

  		add_index :payables, :gl_account_id
  		add_index :receivables, :gl_account_id
  end
end
