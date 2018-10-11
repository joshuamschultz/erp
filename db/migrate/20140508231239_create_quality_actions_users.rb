class CreateQualityActionsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :quality_actions_users do |t|
      t.references :quality_action
      t.references :user

      t.timestamps
    end
    add_index :quality_actions_users, :quality_action_id
    add_index :quality_actions_users, :user_id
  end
end
