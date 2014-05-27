class CreatePrintingScreens < ActiveRecord::Migration
  def change
    create_table :printing_screens do |t|
      t.string :status
      t.references :payment

      t.timestamps
    end
    add_index :printing_screens, :payment_id
  end
end
