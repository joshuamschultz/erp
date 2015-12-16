class AddControlStringSecondToMaxControlString < ActiveRecord::Migration
  def change
    add_column :max_control_strings, :control_string_second, :string
  end
end
