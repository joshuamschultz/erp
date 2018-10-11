class AddSoDueDateToSoHeader < ActiveRecord::Migration[5.0]
  def change
    add_column :so_headers, :so_due_date, :date
  end
end
