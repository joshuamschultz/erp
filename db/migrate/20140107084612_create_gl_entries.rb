class CreateGlEntries < ActiveRecord::Migration
  def change
    create_table :gl_entries do |t|
      t.string :gl_entry_identifier
      t.references :gl_account
      t.string :gl_entry_description
      t.date :gl_entry_date, :default => Date.today
      t.decimal :gl_entry_credit, :precision => 25, :scale => 10, :default => 0
      t.decimal :gl_entry_debit, :precision => 25, :scale => 10, :default => 0
      t.text :gl_entry_notes
      t.boolean :gl_entry_active, :default => true

      t.timestamps
    end
    add_index :gl_entries, :gl_account_id
  end
end
