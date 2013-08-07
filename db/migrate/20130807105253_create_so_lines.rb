class CreateSoLines < ActiveRecord::Migration
  def change
    create_table :so_lines do |t|
      t.string :name

      t.timestamps
    end
  end
end
