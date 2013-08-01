class CreateItemProcesses < ActiveRecord::Migration
  def change
    create_table :item_processes do |t|
      t.references :item
      t.references :process_type

      t.timestamps
    end
    add_index :item_processes, :item_id
    add_index :item_processes, :process_type_id
  end
end
