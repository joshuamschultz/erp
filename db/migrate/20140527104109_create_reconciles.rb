class CreateReconciles < ActiveRecord::Migration
  def change
    create_table :reconciles do |t|
      t.string :reconcile_type
      t.references :payment
      t.string :tag
      t.references :deposit_check
      t.references :printing_screen
      t.string :reconcile_status

      t.timestamps
    end
    add_index :reconciles, :payment_id
    add_index :reconciles, :deposit_check_id
    add_index :reconciles, :printing_screen_id
  end
end
