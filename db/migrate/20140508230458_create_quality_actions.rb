class CreateQualityActions < ActiveRecord::Migration
  def change
    create_table :quality_actions do |t|
      t.integer :quality_action_no
      t.integer :ic_action_id
      t.integer :organization_quality_type_id
      t.references :item
      t.references :item_revision
      t.references :item_alt_name
      t.references :po_header
      t.integer :quantity
      t.text :definition_of_issue
      t.text :short_term_fix
      t.references :cause_analysis
      t.text :required_action
      t.string :quality_action_status
      t.date :due_date
      t.boolean :quality_action_active
      t.datetime :submit_time
      t.integer :created_user_id

      t.timestamps
    end
    add_index :quality_actions, :item_id
    add_index :quality_actions, :item_revision_id
    add_index :quality_actions, :item_alt_name_id
    add_index :quality_actions, :po_header_id
    add_index :quality_actions, :cause_analysis_id
  end
end
