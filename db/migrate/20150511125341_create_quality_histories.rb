class CreateQualityHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :quality_histories do |t|
      t.integer :quality_lot_id
      t.string :quality_status
      t.integer :user_id

      t.timestamps
    end
  end
end
