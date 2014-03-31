class CreateCheckEntries < ActiveRecord::Migration
  def change
    create_table :check_entries do |t|
      t.string :check_identifier
      t.string :check_code
      t.boolean :check_active

      t.timestamps
    end
  end
end
