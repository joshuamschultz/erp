class CreateReconcileds < ActiveRecord::Migration
  def change
    create_table :reconcileds do |t|
      t.float :balance

      t.timestamps
    end
  end
end
