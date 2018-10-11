class AddControlStringSecondToMaxControlString < ActiveRecord::Migration[5.0]
  def change
    add_column :max_control_strings, :control_string_second, :string
  end
end
