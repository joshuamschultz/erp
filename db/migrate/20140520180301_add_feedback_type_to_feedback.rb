class AddFeedbackTypeToFeedback < ActiveRecord::Migration
  def change
  	add_column :customer_feedbacks, :customer_feedback_type_id, :integer
  end
end
