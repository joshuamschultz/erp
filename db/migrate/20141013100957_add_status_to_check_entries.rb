class AddStatusToCheckEntries < ActiveRecord::Migration
  def change
    add_column :check_entries, :status, :string
  end
end
