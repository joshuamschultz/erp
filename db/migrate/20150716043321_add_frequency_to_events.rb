class AddFrequencyToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :frequency, :integer
  end
end
