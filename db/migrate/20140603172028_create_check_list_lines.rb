class CreateCheckListLines < ActiveRecord::Migration
  def change
    create_table :check_list_lines do |t|
      t.references :checklist
      t.references :master_type
      t.boolean :check_list_status

      t.timestamps
    end
    add_index :check_list_lines, :checklist_id
    add_index :check_list_lines, :master_type_id
  end
end
