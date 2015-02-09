class CreateMaxControlStrings < ActiveRecord::Migration
  def change
    create_table :max_control_strings do |t|
      t.string :control_string

      t.timestamps
    end
  end
end
