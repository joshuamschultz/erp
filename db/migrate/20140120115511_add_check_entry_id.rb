class AddCheckEntryId < ActiveRecord::Migration[5.0]
  def up
  		add_column :payments, :check_entry_id, :integer
  		add_column :receipts, :check_entry_id, :integer

  		add_index :payments, :check_entry_id
  		add_index :receipts, :check_entry_id
  end
end
