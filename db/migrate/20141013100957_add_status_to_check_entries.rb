class AddStatusToCheckEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :check_entries, :status, :string
  end
end
