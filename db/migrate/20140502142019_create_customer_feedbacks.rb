class CreateCustomerFeedbacks < ActiveRecord::Migration
  def change
    create_table :customer_feedbacks do |t|
      t.references :organization
      t.string :title
      t.text :feedback
      t.integer :quality_action_id
      t.references :user

      t.timestamps
    end
    add_index :customer_feedbacks, :organization_id
    add_index :customer_feedbacks, :user_id
  end
end
