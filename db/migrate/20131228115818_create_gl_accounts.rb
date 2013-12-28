class CreateGlAccounts < ActiveRecord::Migration
  def change
    create_table :gl_accounts do |t|
      t.references :gl_type
      t.string :gl_title
      t.string :gl_mode
      t.string :gl_category
      t.string :gl_identifier
      t.string :gl_description
      t.boolean :gl_active

      t.timestamps
    end
    add_index :gl_accounts, :gl_type_id
  end
end
