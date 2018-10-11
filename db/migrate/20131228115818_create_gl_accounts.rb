class CreateGlAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :gl_accounts do |t|
      t.references :gl_type
      t.string :gl_account_title
      t.string :gl_account_identifier
      t.string :gl_account_description
      t.boolean :gl_account_active

      t.timestamps
    end
    add_index :gl_accounts, :gl_type_id
  end
end
