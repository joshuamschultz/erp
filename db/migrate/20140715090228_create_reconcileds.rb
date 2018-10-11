class CreateReconcileds < ActiveRecord::Migration[5.0]
  def change
    create_table :reconcileds do |t|
      t.float :balance

      t.timestamps
    end
  end
end
