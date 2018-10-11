class CreateQualityActionNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :quality_action_numbers do |t|
      t.integer :next_action_no, :default => 0

      t.timestamps
    end
  end
end
