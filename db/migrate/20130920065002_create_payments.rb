class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :organization
      t.integer :payment_type_id
      t.string :payment_check_code
      t.decimal :payment_check_amount, :precision => 25, :scale => 10, :default => 0  
      t.string :payment_check_no
      t.string :payment_identifier
      t.string :payment_description
      t.text :payment_notes
      t.string :payment_status
      t.boolean :payment_active
      t.integer :payment_created_id
      t.integer :payment_updated_id

      t.timestamps
    end
    add_index :payments, :organization_id
  end
end
