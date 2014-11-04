class AddSoDueDateToSoHeader < ActiveRecord::Migration
  def change
    add_column :so_headers, :so_due_date, :date
  end
end
