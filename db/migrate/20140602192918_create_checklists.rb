class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.references :quality_lot
      t.string :checklist_status
      t.references :po_line
      t.references :customer_quality

      t.timestamps
    end
    add_index :checklists, :quality_lot_id
    add_index :checklists, :po_line_id
    add_index :checklists, :customer_quality_id
  end
end
